class ApiConstants {
  // 注意: 在实际部署时，这个地址需要修改为您的实际API服务器地址
  // 手机上测试时，应该是Docker主机的IP地址
  // 例如 192.168.1.x:8080，这里的IP需要是Docker主机在局域网中的IP
  
  // 如何获取Docker主机IP:
  // 1. Windows: 打开命令提示符，输入 ipconfig 查看本机IP地址
  // 2. macOS/Linux: 打开终端，输入 ifconfig 或 ip addr 查看本机IP地址
  // 3. 确保您的Docker容器映射了正确的端口（如8080:3000）
  // 4. 确保防火墙允许8080端口的访问
  
  // 本地Android模拟器测试用 - 默认启用此配置进行开发
  // Android模拟器中10.0.2.2对应主机的localhost
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // 真机测试用 - 需要使用Docker主机的实际IP地址
  // 请替换为您的Docker主机的实际IP地址，并取消注释此行，同时注释掉上面的行
  // static const String baseUrl = 'http://192.168.1.100:8080';
  
  // 其他API常量
  static const int connectionTimeout = 10; // 连接超时（秒）
  static const int receiveTimeout = 10;    // 接收超时（秒）
  
  // API路径
  static const String userLoginPath = '/api/users/login';
  static const String userRegisterPath = '/api/users/register';
  static const String userProfilePath = '/api/users/profile';
  static const String nutritionProfilesPath = '/api/nutrition-profiles';
  
  // 在应用启动时打印API配置，方便调试
  static void printConfig() {
    print('=== API配置信息 ===');
    print('基础URL: $baseUrl');
    print('营养档案API: $baseUrl$nutritionProfilesPath');
    print('连接超时: $connectionTimeout秒');
    print('==================');
  }
} 