/**
 * 配送服务
 * 处理配送员分配、路线优化、配送追踪等功能
 */

const Order = require('../../models/order/orderModel');
const geolib = require('geolib');

class DeliveryService {
  constructor() {
    // 模拟配送员数据（实际应该从数据库获取）
    this.deliveryDrivers = [
      {
        id: 'driver1',
        name: '张师傅',
        phone: '13800138001',
        status: 'available', // available, busy, offline
        currentLocation: { lat: 31.2304, lng: 121.4737 },
        currentOrderId: null,
        deliveryCapacity: 5,
        vehicleType: 'motorcycle',
        rating: 4.8,
        todayDeliveries: 0
      },
      {
        id: 'driver2',
        name: '李师傅',
        phone: '13800138002',
        status: 'available',
        currentLocation: { lat: 31.2354, lng: 121.4687 },
        currentOrderId: null,
        deliveryCapacity: 8,
        vehicleType: 'car',
        rating: 4.9,
        todayDeliveries: 0
      },
      {
        id: 'driver3',
        name: '王师傅',
        phone: '13800138003',
        status: 'busy',
        currentLocation: { lat: 31.2254, lng: 121.4787 },
        currentOrderId: 'order123',
        deliveryCapacity: 5,
        vehicleType: 'ebike',
        rating: 4.7,
        todayDeliveries: 3
      }
    ];
  }

  /**
   * 分配最合适的配送员
   */
  async assignDeliveryDriver(orderId) {
    try {
      const order = await Order.findById(orderId).populate('merchantId');
      if (!order) {
        throw new Error('订单不存在');
      }

      if (order.orderType !== 'delivery') {
        throw new Error('该订单不是配送订单');
      }

      // 获取可用的配送员
      const availableDrivers = this.deliveryDrivers.filter(driver => 
        driver.status === 'available'
      );

      if (availableDrivers.length === 0) {
        throw new Error('暂无可用配送员');
      }

      // 计算每个配送员到商家的距离
      const merchantLocation = {
        lat: order.merchantId.location?.coordinates[1] || 31.2304,
        lng: order.merchantId.location?.coordinates[0] || 121.4737
      };

      const driversWithDistance = availableDrivers.map(driver => {
        const distance = geolib.getDistance(
          { latitude: driver.currentLocation.lat, longitude: driver.currentLocation.lng },
          { latitude: merchantLocation.lat, longitude: merchantLocation.lng }
        );
        return { ...driver, distance };
      });

      // 按距离排序，选择最近的配送员
      driversWithDistance.sort((a, b) => a.distance - b.distance);
      const selectedDriver = driversWithDistance[0];

      // 更新配送员状态
      selectedDriver.status = 'busy';
      selectedDriver.currentOrderId = orderId;

      // 更新订单信息
      order.delivery = order.delivery || {};
      order.delivery.driverId = selectedDriver.id;
      order.delivery.driverName = selectedDriver.name;
      order.delivery.driverPhone = selectedDriver.phone;
      order.delivery.assignedAt = new Date();
      order.delivery.estimatedPickupTime = new Date(Date.now() + selectedDriver.distance / 1000 * 60 * 1000); // 根据距离估算取餐时间

      // 计算预计送达时间
      const customerLocation = order.delivery.coordinates || { lat: 31.2404, lng: 121.4837 };
      const deliveryDistance = geolib.getDistance(
        { latitude: merchantLocation.lat, longitude: merchantLocation.lng },
        { latitude: customerLocation.lat, longitude: customerLocation.lng }
      );
      
      order.delivery.estimatedDeliveryTime = new Date(
        order.delivery.estimatedPickupTime.getTime() + deliveryDistance / 1000 * 60 * 1000
      );

      await order.save();

      return {
        success: true,
        driver: {
          id: selectedDriver.id,
          name: selectedDriver.name,
          phone: selectedDriver.phone,
          vehicleType: selectedDriver.vehicleType,
          rating: selectedDriver.rating,
          estimatedPickupTime: order.delivery.estimatedPickupTime,
          estimatedDeliveryTime: order.delivery.estimatedDeliveryTime
        }
      };

    } catch (error) {
      console.error('分配配送员失败:', error);
      throw error;
    }
  }

  /**
   * 更新配送员位置
   */
  updateDriverLocation(driverId, location) {
    const driver = this.deliveryDrivers.find(d => d.id === driverId);
    if (driver) {
      driver.currentLocation = location;
      return true;
    }
    return false;
  }

  /**
   * 获取配送员状态
   */
  getDriverStatus(driverId) {
    const driver = this.deliveryDrivers.find(d => d.id === driverId);
    return driver || null;
  }

  /**
   * 获取所有配送员状态
   */
  getAllDrivers() {
    return this.deliveryDrivers.map(driver => ({
      id: driver.id,
      name: driver.name,
      status: driver.status,
      currentLocation: driver.currentLocation,
      vehicleType: driver.vehicleType,
      rating: driver.rating,
      todayDeliveries: driver.todayDeliveries,
      currentOrderId: driver.currentOrderId
    }));
  }

  /**
   * 配送员取餐
   */
  async driverPickupOrder(orderId, driverId) {
    try {
      const order = await Order.findById(orderId);
      if (!order) {
        throw new Error('订单不存在');
      }

      if (order.delivery.driverId !== driverId) {
        throw new Error('配送员与订单不匹配');
      }

      order.delivery.pickupTime = new Date();
      order.updateStatus('in_delivery');
      await order.save();

      return {
        success: true,
        message: '取餐成功',
        estimatedDeliveryTime: order.delivery.estimatedDeliveryTime
      };

    } catch (error) {
      console.error('配送员取餐失败:', error);
      throw error;
    }
  }

  /**
   * 完成配送
   */
  async completeDelivery(orderId, driverId, deliveryProof) {
    try {
      const order = await Order.findById(orderId);
      if (!order) {
        throw new Error('订单不存在');
      }

      if (order.delivery.driverId !== driverId) {
        throw new Error('配送员与订单不匹配');
      }

      // 更新订单状态
      order.delivery.actualDeliveryTime = new Date();
      order.delivery.deliveryProof = deliveryProof; // 签收照片等
      order.updateStatus('delivered');
      await order.save();

      // 更新配送员状态
      const driver = this.deliveryDrivers.find(d => d.id === driverId);
      if (driver) {
        driver.status = 'available';
        driver.currentOrderId = null;
        driver.todayDeliveries++;
      }

      return {
        success: true,
        message: '配送完成',
        deliveryTime: order.delivery.actualDeliveryTime
      };

    } catch (error) {
      console.error('完成配送失败:', error);
      throw error;
    }
  }

  /**
   * 获取配送路线
   */
  async getDeliveryRoute(orderId) {
    try {
      const order = await Order.findById(orderId).populate('merchantId');
      if (!order) {
        throw new Error('订单不存在');
      }

      const driver = this.deliveryDrivers.find(d => d.id === order.delivery.driverId);
      if (!driver) {
        throw new Error('配送员不存在');
      }

      const merchantLocation = {
        lat: order.merchantId.location?.coordinates[1] || 31.2304,
        lng: order.merchantId.location?.coordinates[0] || 121.4737,
        address: order.merchantId.address
      };

      const customerLocation = {
        lat: order.delivery.coordinates?.lat || 31.2404,
        lng: order.delivery.coordinates?.lng || 121.4837,
        address: order.delivery.address
      };

      const route = {
        driver: {
          name: driver.name,
          currentLocation: driver.currentLocation,
          vehicleType: driver.vehicleType
        },
        waypoints: [
          {
            type: 'current',
            location: driver.currentLocation,
            label: '配送员当前位置'
          },
          {
            type: 'pickup',
            location: merchantLocation,
            label: '取餐点',
            estimatedArrival: order.delivery.estimatedPickupTime
          },
          {
            type: 'delivery',
            location: customerLocation,
            label: '送餐点',
            estimatedArrival: order.delivery.estimatedDeliveryTime
          }
        ],
        totalDistance: this.calculateTotalDistance([
          driver.currentLocation,
          merchantLocation,
          customerLocation
        ]),
        status: order.status
      };

      return route;

    } catch (error) {
      console.error('获取配送路线失败:', error);
      throw error;
    }
  }

  /**
   * 计算总距离
   */
  calculateTotalDistance(points) {
    let totalDistance = 0;
    for (let i = 0; i < points.length - 1; i++) {
      const distance = geolib.getDistance(
        { latitude: points[i].lat, longitude: points[i].lng },
        { latitude: points[i + 1].lat, longitude: points[i + 1].lng }
      );
      totalDistance += distance;
    }
    return totalDistance;
  }

  /**
   * 批量分配订单（智能调度）
   */
  async batchAssignOrders(orderIds) {
    const results = [];
    
    // TODO: 实现更智能的批量分配算法
    // 考虑因素：配送员位置、订单位置、配送员容量、时间窗口等
    
    for (const orderId of orderIds) {
      try {
        const result = await this.assignDeliveryDriver(orderId);
        results.push({ orderId, success: true, driver: result.driver });
      } catch (error) {
        results.push({ orderId, success: false, error: error.message });
      }
    }
    
    return results;
  }
}

module.exports = new DeliveryService();