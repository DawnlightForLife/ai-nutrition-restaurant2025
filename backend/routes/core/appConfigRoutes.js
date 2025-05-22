const express = require('express');
const router = express.Router();
const { createAppConfig, getAppConfigList, getAppConfigById, updateAppConfig, deleteAppConfig } = require('../../controllers/misc/appConfigController');

/**
 * 应用配置管理路由
 * 提供创建、获取、更新、删除应用配置的接口
 * @module routes/misc/appConfigRoutes
 */

/**
 * @swagger
 * /api/config:
 *   post:
 *     summary: 创建应用配置
 *     tags: [配置管理]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - key
 *               - value
 *             properties:
 *               key:
 *                 type: string
 *                 description: 配置键名
 *               value:
 *                 type: string
 *                 description: 配置值
 *               description:
 *                 type: string
 *                 description: 配置说明
 *     responses:
 *       201:
 *         description: 创建成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 */
router.post('/', createAppConfig);

/**
 * @swagger
 * /api/config:
 *   get:
 *     summary: 获取应用配置列表
 *     tags: [配置管理]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: 页码
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *         description: 每页数量
 *     responses:
 *       200:
 *         description: 获取成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 */
router.get('/', getAppConfigList);

/**
 * @swagger
 * /api/config/{id}:
 *   get:
 *     summary: 获取指定应用配置详情
 *     tags: [配置管理]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 配置ID
 *     responses:
 *       200:
 *         description: 获取成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 */
router.get('/:id', getAppConfigById);

/**
 * @swagger
 * /api/config/{id}:
 *   put:
 *     summary: 更新应用配置
 *     tags: [配置管理]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 配置ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               value:
 *                 type: string
 *                 description: 配置值
 *               description:
 *                 type: string
 *                 description: 配置说明
 *     responses:
 *       200:
 *         description: 更新成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 */
router.put('/:id', updateAppConfig);

/**
 * @swagger
 * /api/config/{id}:
 *   delete:
 *     summary: 删除应用配置
 *     tags: [配置管理]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 配置ID
 *     responses:
 *       200:
 *         description: 删除成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 */
router.delete('/:id', deleteAppConfig);

module.exports = router;
