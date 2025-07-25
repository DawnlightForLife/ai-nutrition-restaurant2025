# AI智能营养餐厅系统 - 数据库运维文档

> **文档版本**: 1.0.0  
> **创建日期**: 2025-07-12  
> **更新日期**: 2025-07-12  
> **文档状态**: ✅ 数据库运维就绪  
> **目标受众**: DBA、运维工程师、开发团队、技术负责人

## 📋 目录

- [1. 数据库架构概述](#1-数据库架构概述)
- [2. 日常运维管理](#2-日常运维管理)
- [3. 性能优化](#3-性能优化)
- [4. 备份与恢复](#4-备份与恢复)
- [5. 高可用与容灾](#5-高可用与容灾)
- [6. 安全管理](#6-安全管理)
- [7. 监控与告警](#7-监控与告警)
- [8. 故障处理](#8-故障处理)
- [9. 数据库升级](#9-数据库升级)
- [10. pgvector特性管理](#10-pgvector特性管理)

---

## 1. 数据库架构概述

### 1.1 技术栈与版本

```yaml
数据库技术栈:
  主数据库:
    类型: "PostgreSQL"
    版本: "15.4"
    扩展:
      - pgvector: "0.5.0"
      - pg_stat_statements: "1.10"
      - pg_repack: "1.4.8"
      - postgres_fdw: "1.1"
      - uuid-ossp: "1.1"
      
  缓存层:
    Redis:
      版本: "7.0.12"
      模式: "主从 + 哨兵"
      用途: "会话、缓存、计数器"
      
  向量数据库:
    pgvector:
      版本: "0.5.0"
      用途: "营养特征向量存储"
      维度: "1536维 (基于OpenAI标准嵌入)"
```

### 1.2 部署架构

```yaml
部署架构设计:
  主从架构:
    主库 (Master):
      服务器: "db-master-01"
      配置: "64核 256GB内存 2TB SSD"
      角色: "读写操作"
      
    从库 (Slave):
      同步从库:
        - db-slave-01: "同步复制"
        - db-slave-02: "同步复制"
      异步从库:
        - db-slave-03: "异步复制 (报表库)"
        - db-slave-04: "异步复制 (分析库)"
        
  读写分离:
    写操作: "全部路由到主库"
    读操作:
      实时查询: "主库或同步从库"
      统计查询: "异步从库"
      报表查询: "专用报表库"
      
  分库分表:
    用户数据: "按user_id哈希分片"
    订单数据: "按时间范围分表"
    日志数据: "按日期分区"
```

### 1.3 数据库清单

```yaml
数据库实例:
  业务数据库:
    nutrition_main:
      描述: "核心业务数据"
      表数量: "约50个"
      数据量: "预估100GB/年"
      
    nutrition_user:
      描述: "用户相关数据"
      表数量: "约20个"
      数据量: "预估500GB/年"
      
    nutrition_order:
      描述: "订单交易数据"
      表数量: "约15个"
      数据量: "预估1TB/年"
      
  辅助数据库:
    nutrition_analytics:
      描述: "数据分析库"
      表数量: "约30个"
      数据量: "预估2TB/年"
      
    nutrition_log:
      描述: "日志归档库"
      表数量: "约10个"
      数据量: "预估5TB/年"
```

---

## 2. 日常运维管理

### 2.1 日常巡检

```yaml
每日巡检任务:
  基础检查:
    - 检查数据库服务状态
    - 检查主从同步状态
    - 检查连接数使用情况
    - 检查表空间使用率
    - 检查错误日志
    
  性能检查:
    - 检查慢查询日志
    - 检查锁等待情况
    - 检查缓存命中率
    - 检查索引使用情况
    
  巡检脚本:
    daily_check.sh: |
      #!/bin/bash
      # 数据库状态检查
      psql -c "SELECT version();"
      psql -c "SELECT pg_is_in_recovery();"
      
      # 主从同步检查
      psql -c "SELECT * FROM pg_stat_replication;"
      
      # 连接数检查
      psql -c "SELECT count(*) FROM pg_stat_activity;"
      
      # 表空间检查
      psql -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database;"
      
      # 慢查询检查
      psql -c "SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;"
```

### 2.2 用户权限管理

```yaml
权限管理策略:
  用户分类:
    超级管理员:
      用户: "postgres"
      权限: "所有权限"
      使用场景: "紧急维护"
      
    应用用户:
      app_writer:
        权限: "SELECT, INSERT, UPDATE, DELETE"
        数据库: "nutrition_main, nutrition_user, nutrition_order"
        
      app_reader:
        权限: "SELECT"
        数据库: "所有业务库"
        
    运维用户:
      dba_admin:
        权限: "管理权限，无超级用户"
        用途: "日常维护"
        
      backup_user:
        权限: "SELECT, REPLICATION"
        用途: "备份操作"
        
    分析用户:
      analyst_user:
        权限: "SELECT"
        数据库: "nutrition_analytics"
        限制: "只能访问分析库"
        
  权限管理脚本:
    create_app_user.sql: |
      -- 创建应用写用户
      CREATE USER app_writer WITH PASSWORD 'secure_password';
      GRANT CONNECT ON DATABASE nutrition_main TO app_writer;
      GRANT USAGE ON SCHEMA public TO app_writer;
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_writer;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_writer;
      
      -- 创建只读用户
      CREATE USER app_reader WITH PASSWORD 'secure_password';
      GRANT CONNECT ON DATABASE nutrition_main TO app_reader;
      GRANT USAGE ON SCHEMA public TO app_reader;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_reader;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO app_reader;
```

### 2.3 连接池管理

```yaml
连接池配置:
  PgBouncer配置:
    pool_mode: "transaction"
    max_client_conn: 1000
    default_pool_size: 25
    reserve_pool_size: 5
    server_lifetime: 3600
    
  应用连接配置:
    写连接池:
      min_size: 10
      max_size: 50
      idle_timeout: 300
      
    读连接池:
      min_size: 20
      max_size: 100
      idle_timeout: 600
      
  监控指标:
    - 活跃连接数
    - 空闲连接数
    - 等待连接数
    - 连接使用率
```

---

## 3. 性能优化

### 3.1 查询优化

```yaml
查询优化策略:
  慢查询分析:
    配置参数:
      log_min_duration_statement: 1000  # 记录超过1秒的查询
      shared_preload_libraries: 'pg_stat_statements'
      pg_stat_statements.track: 'all'
      
    分析工具:
      - pg_stat_statements: "统计查询性能"
      - EXPLAIN ANALYZE: "查询计划分析"
      - pgBadger: "日志分析报告"
      
  索引优化:
    索引策略:
      - B-tree索引: "常规字段查询"
      - GiST索引: "地理位置查询"
      - GIN索引: "全文搜索、JSON查询"
      - BRIN索引: "时序数据"
      - IVFFlat索引: "向量相似度查询"
      
    索引维护:
      定期重建: "REINDEX CONCURRENTLY"
      索引膨胀检查: "使用pgstattuple"
      无用索引清理: "基于pg_stat_user_indexes"
      
  查询重写:
    优化技巧:
      - 避免SELECT *
      - 使用LIMIT限制结果集
      - 合理使用JOIN顺序
      - 使用物化视图
      - 批量操作代替循环
```

### 3.2 参数调优

```yaml
PostgreSQL参数优化:
  内存相关:
    shared_buffers: "64GB"  # 物理内存的25%
    effective_cache_size: "192GB"  # 物理内存的75%
    work_mem: "256MB"
    maintenance_work_mem: "2GB"
    
  检查点相关:
    checkpoint_timeout: "15min"
    checkpoint_completion_target: "0.9"
    max_wal_size: "4GB"
    min_wal_size: "1GB"
    
  并发相关:
    max_connections: "500"
    max_worker_processes: "16"
    max_parallel_workers_per_gather: "4"
    max_parallel_workers: "16"
    
  查询优化器:
    random_page_cost: "1.1"  # SSD优化
    effective_io_concurrency: "200"
    default_statistics_target: "100"
    
  日志相关:
    log_min_duration_statement: "1000"
    log_checkpoints: "on"
    log_connections: "on"
    log_disconnections: "on"
    log_lock_waits: "on"
    log_temp_files: "0"
```

### 3.3 表优化

```yaml
表维护策略:
  VACUUM操作:
    自动VACUUM:
      autovacuum: "on"
      autovacuum_max_workers: "4"
      autovacuum_naptime: "1min"
      autovacuum_vacuum_threshold: "50"
      autovacuum_analyze_threshold: "50"
      
    手动VACUUM:
      日常维护: "VACUUM ANALYZE"
      深度清理: "VACUUM FULL"
      并发清理: "pg_repack"
      
  表分区:
    分区策略:
      订单表: "按月范围分区"
      日志表: "按日列表分区"
      用户表: "按user_id哈希分区"
      
    分区维护:
      自动创建: "使用pg_partman"
      自动清理: "定期删除旧分区"
      分区合并: "历史数据归档"
      
  统计信息:
    更新频率:
      高频表: "每小时"
      普通表: "每天"
      静态表: "每周"
      
    统计脚本: |
      -- 更新表统计信息
      ANALYZE users;
      ANALYZE orders;
      ANALYZE nutrition_records;
```

---

## 4. 备份与恢复

### 4.1 备份策略

```yaml
备份体系:
  物理备份:
    全量备份:
      工具: "pg_basebackup"
      频率: "每日一次"
      时间: "凌晨2:00"
      保留: "7天"
      
    增量备份:
      工具: "pgBackRest"
      频率: "每4小时"
      保留: "24小时"
      
    归档备份:
      WAL归档: "连续归档"
      归档位置: "远程存储"
      保留策略: "30天"
      
  逻辑备份:
    全库备份:
      工具: "pg_dump"
      频率: "每周一次"
      格式: "custom格式"
      压缩: "是"
      
    表级备份:
      重要表: "每日备份"
      静态表: "每月备份"
      
  备份脚本:
    physical_backup.sh: |
      #!/bin/bash
      BACKUP_DIR="/backup/postgresql/$(date +%Y%m%d)"
      mkdir -p $BACKUP_DIR
      
      # 执行基础备份
      pg_basebackup -D $BACKUP_DIR -Ft -z -Xs -P -U backup_user
      
      # 验证备份
      pg_verifybackup $BACKUP_DIR
      
      # 上传到远程存储
      aws s3 sync $BACKUP_DIR s3://backup-bucket/postgresql/
```

### 4.2 恢复策略

```yaml
恢复场景:
  时间点恢复 (PITR):
    步骤:
      1. 恢复基础备份
      2. 配置recovery.conf
      3. 应用WAL日志
      4. 恢复到指定时间点
      
    恢复脚本: |
      # 恢复基础备份
      tar -xzf /backup/base_backup.tar.gz -C /pgdata
      
      # 配置恢复参数
      cat > /pgdata/postgresql.auto.conf << EOF
      restore_command = 'cp /archive/%f %p'
      recovery_target_time = '2025-07-12 10:00:00'
      recovery_target_action = 'promote'
      EOF
      
      # 启动恢复
      pg_ctl start -D /pgdata
      
  表级恢复:
    单表恢复:
      - 从逻辑备份恢复
      - 使用pg_restore选择性恢复
      - 处理外键依赖
      
  灾难恢复:
    完整恢复流程:
      1. 准备新服务器
      2. 恢复最近的全量备份
      3. 应用增量备份
      4. 应用WAL日志
      5. 验证数据完整性
      6. 切换应用连接
```

### 4.3 备份验证

```yaml
备份验证流程:
  自动验证:
    验证内容:
      - 备份文件完整性
      - 备份大小合理性
      - 备份可恢复性
      
    验证脚本:
      定期恢复测试: "每周一次"
      恢复到测试环境: "验证数据一致性"
      性能基准对比: "确保恢复后性能正常"
      
  手动验证:
    月度验证:
      - 随机选择备份恢复
      - 业务功能测试
      - 数据完整性检查
      
    年度演练:
      - 完整灾难恢复演练
      - 跨数据中心恢复
      - 恢复时间评估
```

---

## 5. 高可用与容灾

### 5.1 主从复制

```yaml
流复制配置:
  主库配置:
    postgresql.conf: |
      wal_level = replica
      max_wal_senders = 10
      wal_keep_size = 1GB
      synchronous_standby_names = 'sync_slave1,sync_slave2'
      synchronous_commit = remote_write
      
    pg_hba.conf: |
      # 复制用户访问控制
      host replication repl_user slave1_ip/32 md5
      host replication repl_user slave2_ip/32 md5
      
  从库配置:
    同步从库:
      recovery_target_timeline: 'latest'
      primary_conninfo: 'host=master_ip user=repl_user'
      primary_slot_name: 'slave1_slot'
      
    异步从库:
      recovery_target_timeline: 'latest'
      primary_conninfo: 'host=master_ip user=repl_user application_name=async_slave'
      
  复制监控:
    监控指标:
      - 复制延迟 (lag)
      - WAL发送/接收速率
      - 复制槽状态
      - 连接状态
```

### 5.2 故障切换

```yaml
自动故障切换:
  Patroni配置:
    集群配置:
      scope: nutrition_cluster
      name: patroni1
      
    PostgreSQL参数:
      max_connections: 500
      shared_buffers: 64GB
      
    故障检测:
      ttl: 30
      loop_wait: 10
      retry_timeout: 10
      maximum_lag_on_failover: 1048576
      
  手动切换流程:
    计划内切换:
      1. 检查主从同步状态
      2. 确保无长事务
      3. 执行switchover命令
      4. 验证新主库状态
      5. 更新应用配置
      
    紧急切换:
      1. 确认主库故障
      2. 选择最新的从库
      3. 提升从库为主库
      4. 重新配置其他从库
      5. 处理数据差异
```

### 5.3 负载均衡

```yaml
读写分离架构:
  连接路由:
    写请求:
      目标: "主库"
      连接池: "独立写连接池"
      
    读请求:
      实时读: "主库或同步从库"
      延迟容忍读: "任意从库"
      报表查询: "专用分析从库"
      
  负载均衡策略:
    HAProxy配置:
      写服务:
        - master:5432 (weight=100)
        
      读服务:
        - slave1:5432 (weight=30)
        - slave2:5432 (weight=30)
        - slave3:5432 (weight=20)
        - slave4:5432 (weight=20)
        
    健康检查:
      检查间隔: "2秒"
      超时时间: "5秒"
      失败阈值: "3次"
```

---

## 6. 安全管理

### 6.1 访问控制

```yaml
安全策略:
  网络隔离:
    数据库网段: "独立私有网段"
    访问控制: "白名单机制"
    VPN访问: "运维人员远程访问"
    
  认证配置:
    pg_hba.conf: |
      # 本地连接
      local all all md5
      
      # 应用服务器
      host all app_user app_subnet/24 md5
      
      # 运维访问
      host all dba_user vpn_subnet/24 md5 clientcert=1
      
      # 拒绝其他
      host all all 0.0.0.0/0 reject
      
  SSL/TLS配置:
    服务端配置:
      ssl: "on"
      ssl_cert_file: "server.crt"
      ssl_key_file: "server.key"
      ssl_ca_file: "ca.crt"
      ssl_ciphers: "HIGH:MEDIUM:+3DES:!aNULL"
      
    客户端要求:
      sslmode: "require"
      sslcert: "client.crt"
      sslkey: "client.key"
```

### 6.2 数据加密

```yaml
加密策略:
  传输加密:
    协议: "TLS 1.3"
    证书: "企业CA签发"
    强制加密: "所有连接必须加密"
    
  存储加密:
    表空间加密:
      工具: "pgcrypto扩展"
      算法: "AES-256"
      密钥管理: "外部密钥管理系统"
      
    字段加密:
      敏感字段: |
        -- 加密存储
        INSERT INTO users (phone) 
        VALUES (pgp_sym_encrypt('13800138000', 'secret_key'));
        
        -- 解密查询
        SELECT pgp_sym_decrypt(phone, 'secret_key') 
        FROM users;
        
  备份加密:
    备份文件: "GPG加密"
    传输通道: "SSH/SSL"
    存储位置: "加密存储"
```

### 6.3 审计日志

```yaml
审计配置:
  pgAudit配置:
    shared_preload_libraries: 'pgaudit'
    pgaudit.log: 'all'
    pgaudit.log_catalog: 'off'
    pgaudit.log_parameter: 'on'
    pgaudit.log_relation: 'on'
    
  审计内容:
    DDL操作: "CREATE, ALTER, DROP"
    权限变更: "GRANT, REVOKE"
    数据访问: "SELECT (敏感表)"
    数据修改: "INSERT, UPDATE, DELETE"
    
  日志管理:
    存储位置: "独立审计服务器"
    保留期限: "3年"
    访问控制: "只读权限"
    定期审查: "每月审计报告"
```

---

## 7. 监控与告警

### 7.1 监控指标

```yaml
关键监控指标:
  系统级指标:
    - 数据库进程状态
    - CPU使用率
    - 内存使用率
    - 磁盘I/O
    - 网络流量
    
  数据库指标:
    连接相关:
      - 当前连接数
      - 等待连接数
      - 空闲连接数
      - 连接使用率
      
    性能相关:
      - TPS (每秒事务数)
      - QPS (每秒查询数)
      - 响应时间分布
      - 慢查询数量
      
    复制相关:
      - 复制延迟
      - WAL生成速率
      - 复制槽状态
      
    资源相关:
      - 缓存命中率
      - 临时文件使用
      - 死锁数量
      - 锁等待
```

### 7.2 监控工具

```yaml
监控工具集成:
  Prometheus + Grafana:
    postgres_exporter:
      版本: "0.13.0"
      采集间隔: "30秒"
      
    监控面板:
      - PostgreSQL Overview
      - Replication Dashboard
      - Query Performance
      - Connection Pool Status
      
  pg_stat_monitor:
    功能增强:
      - 查询计划捕获
      - 等待事件分析
      - 直方图统计
      
  自定义监控:
    监控脚本:
      check_replication.sh: |
        #!/bin/bash
        # 检查复制延迟
        LAG=$(psql -t -c "SELECT pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) FROM pg_stat_replication;")
        if [ $LAG -gt 1000000 ]; then
          echo "WARNING: Replication lag is high: $LAG bytes"
        fi
```

### 7.3 告警规则

```yaml
告警配置:
  紧急告警:
    数据库宕机:
      条件: "数据库进程不存在"
      通知: "电话 + 短信"
      
    主从复制中断:
      条件: "复制连接断开超过1分钟"
      通知: "短信 + 钉钉"
      
    磁盘空间不足:
      条件: "可用空间 < 10%"
      通知: "短信 + 邮件"
      
  警告告警:
    高连接数:
      条件: "连接数 > 80%最大值"
      通知: "钉钉 + 邮件"
      
    慢查询过多:
      条件: "慢查询 > 50/分钟"
      通知: "邮件"
      
    缓存命中率低:
      条件: "命中率 < 90%"
      通知: "邮件"
```

---

## 8. 故障处理

### 8.1 常见故障处理

```yaml
故障处理手册:
  连接数耗尽:
    症状:
      - "FATAL: too many connections"
      - 新连接无法建立
      
    处理步骤:
      1. 使用超级用户预留连接登录
      2. 查看当前连接状态
      3. 终止空闲或异常连接
      4. 调整连接池配置
      5. 必要时增加max_connections
      
    处理脚本: |
      -- 查看连接状态
      SELECT pid, usename, application_name, state, 
             query_start, state_change 
      FROM pg_stat_activity 
      ORDER BY query_start;
      
      -- 终止空闲连接
      SELECT pg_terminate_backend(pid) 
      FROM pg_stat_activity 
      WHERE state = 'idle' 
      AND query_start < now() - interval '10 minutes';
      
  表膨胀:
    症状:
      - 表大小异常增长
      - 查询性能下降
      - VACUUM时间过长
      
    处理步骤:
      1. 检查表膨胀率
      2. 分析膨胀原因
      3. 执行VACUUM FULL或pg_repack
      4. 调整autovacuum参数
      
  死锁:
    症状:
      - "deadlock detected"错误
      - 事务被自动回滚
      
    处理步骤:
      1. 分析死锁日志
      2. 识别冲突的事务
      3. 优化事务逻辑
      4. 调整锁等待超时
```

### 8.2 紧急恢复流程

```yaml
紧急恢复SOP:
  数据库崩溃恢复:
    步骤:
      1. 检查PostgreSQL进程状态
      2. 检查系统日志和数据库日志
      3. 尝试正常启动
      4. 如失败，进入单用户模式
      5. 执行必要的修复操作
      6. 重建损坏的索引
      7. 验证数据完整性
      
  数据损坏恢复:
    步骤:
      1. 立即停止数据库
      2. 备份当前数据目录
      3. 从最近的备份恢复
      4. 应用WAL日志
      5. 检查数据一致性
      6. 处理丢失的数据
      
  主库故障切换:
    步骤:
      1. 确认主库无法恢复
      2. 选择数据最新的从库
      3. 停止其他从库的复制
      4. 提升选定从库为新主库
      5. 重新配置其他从库指向新主库
      6. 更新应用连接配置
      7. 验证服务恢复正常
```

### 8.3 故障预防

```yaml
预防措施:
  定期健康检查:
    每日检查:
      - 表膨胀情况
      - 索引使用情况
      - 连接池状态
      - 复制延迟
      
    每周检查:
      - 慢查询分析
      - 索引维护建议
      - 表统计信息更新
      - 备份验证
      
  容量规划:
    监控趋势:
      - 数据增长率
      - 连接数趋势
      - 查询量趋势
      - 资源使用趋势
      
    扩容建议:
      - 提前3个月规划
      - 保留30%余量
      - 定期压力测试
```

---

## 9. 数据库升级

### 9.1 升级策略

```yaml
升级计划:
  小版本升级:
    频率: "每季度评估"
    方法: "滚动升级"
    步骤:
      1. 先升级从库
      2. 验证从库正常
      3. 切换主从
      4. 升级原主库
      
  大版本升级:
    评估内容:
      - 新特性收益
      - 兼容性影响
      - 性能改进
      - 安全增强
      
    升级方法:
      逻辑升级: "pg_dump/pg_restore"
      物理升级: "pg_upgrade"
      复制升级: "逻辑复制过渡"
```

### 9.2 升级流程

```yaml
升级执行流程:
  准备阶段:
    1. 完整备份当前数据库
    2. 在测试环境验证升级
    3. 检查应用兼容性
    4. 准备回滚方案
    
  执行阶段:
    1. 发布升级公告
    2. 停止应用写入（维护模式）
    3. 执行最终备份
    4. 进行数据库升级
    5. 验证升级结果
    6. 恢复应用访问
    
  验证阶段:
    1. 功能测试
    2. 性能测试
    3. 数据一致性检查
    4. 监控指标确认
    
  回滚方案:
    触发条件:
      - 升级失败
      - 严重性能退化
      - 数据不一致
      
    回滚步骤:
      1. 停止应用访问
      2. 从备份恢复
      3. 验证数据完整性
      4. 恢复应用服务
```

---

## 10. pgvector特性管理

### 10.1 向量索引管理

```yaml
向量索引配置:
  索引类型:
    IVFFlat索引:
      lists: 100  # 聚类中心数
      适用场景: "中等规模向量检索"
      
      创建示例: |
        CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100);
        
    HNSW索引:
      m: 16  # 连接数
      ef_construction: 64
      适用场景: "高性能向量检索"
      
      创建示例: |
        CREATE INDEX ON items USING hnsw (embedding vector_l2_ops) WITH (m = 16, ef_construction = 64);
        
  索引维护:
    定期重建: "数据量增长50%时"
    性能监控: "查询响应时间"
    参数调优: "基于查询模式"
```

### 10.2 向量查询优化

```yaml
查询优化技巧:
  相似度搜索:
    基础查询: |
      SELECT * FROM items 
      ORDER BY embedding <-> '[1,2,3,...]'::vector 
      LIMIT 10;
      
    带过滤的查询: |
      SELECT * FROM items 
      WHERE category = 'food' 
      ORDER BY embedding <-> query_vector 
      LIMIT 10;
      
  批量查询:
    并行处理: "使用pg_parallel"
    分片查询: "按ID范围分片"
    结果合并: "应用层聚合"
    
  性能优化:
    预计算: "常用查询向量缓存"
    降维: "PCA降维优化"
    量化: "向量量化压缩"
```

### 10.3 向量数据管理

```yaml
数据管理策略:
  存储优化:
    向量维度: "1536维 (OpenAI标准)"
    数据类型: "vector(1536)"
    压缩策略: "TOAST自动压缩"
    
  数据质量:
    归一化: "L2范数归一化"
    去重: "余弦相似度阈值"
    更新策略: "增量更新"
    
  备份恢复:
    备份注意: "包含向量索引"
    恢复验证: "向量查询测试"
    迁移工具: "pg_dump支持vector类型"
```

---

## 附录

### A. 运维脚本集

```bash
# 数据库健康检查脚本
cat > /opt/scripts/db_health_check.sh << 'EOF'
#!/bin/bash
# PostgreSQL健康检查脚本

# 数据库连接信息
export PGHOST=localhost
export PGPORT=5432
export PGUSER=monitor_user
export PGPASSWORD=monitor_pass
export PGDATABASE=postgres

# 检查数据库服务状态
check_service() {
    if pg_isready; then
        echo "✓ 数据库服务正常"
    else
        echo "✗ 数据库服务异常"
        exit 1
    fi
}

# 检查连接数
check_connections() {
    CURRENT=$(psql -t -c "SELECT count(*) FROM pg_stat_activity;")
    MAX=$(psql -t -c "SHOW max_connections;")
    PERCENT=$((CURRENT * 100 / MAX))
    
    echo "连接数: $CURRENT/$MAX ($PERCENT%)"
    if [ $PERCENT -gt 80 ]; then
        echo "⚠ 警告: 连接数使用率过高"
    fi
}

# 检查复制状态
check_replication() {
    SLAVES=$(psql -t -c "SELECT count(*) FROM pg_stat_replication;")
    if [ $SLAVES -gt 0 ]; then
        echo "✓ 复制状态正常 (从库数: $SLAVES)"
        psql -c "SELECT client_addr, state, sync_state FROM pg_stat_replication;"
    else
        echo "⚠ 警告: 没有活跃的从库"
    fi
}

# 检查表膨胀
check_bloat() {
    echo "表膨胀检查:"
    psql -c "
    SELECT schemaname, tablename, 
           pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as size,
           round(100 * pg_relation_size(schemaname||'.'||tablename) / 
                 greatest(pg_stat_get_live_tuples(c.oid), 1)) as bloat_ratio
    FROM pg_tables t
    JOIN pg_class c ON c.relname = t.tablename
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    ORDER BY bloat_ratio DESC
    LIMIT 10;"
}

# 执行所有检查
echo "=== PostgreSQL 健康检查 ==="
echo "时间: $(date)"
echo "=========================="
check_service
check_connections
check_replication
check_bloat
echo "=========================="
EOF

chmod +x /opt/scripts/db_health_check.sh
```

### B. 参数优化模板

```yaml
# PostgreSQL 15 优化配置模板
# 服务器配置: 64核 256GB内存 SSD存储

# 内存设置
shared_buffers = 64GB
huge_pages = try
effective_cache_size = 192GB
work_mem = 256MB
maintenance_work_mem = 2GB

# 并发设置
max_connections = 500
max_worker_processes = 64
max_parallel_workers_per_gather = 4
max_parallel_workers = 32
max_parallel_maintenance_workers = 4

# WAL设置
wal_level = replica
wal_buffers = 64MB
checkpoint_timeout = 15min
checkpoint_completion_target = 0.9
max_wal_size = 4GB
min_wal_size = 1GB
archive_mode = on
archive_command = 'cp %p /archive/%f'

# 查询优化
random_page_cost = 1.1
effective_io_concurrency = 200
default_statistics_target = 100
jit = on

# 复制设置
max_wal_senders = 10
wal_keep_size = 2GB
synchronous_standby_names = 'FIRST 2 (slave1, slave2)'
hot_standby = on
hot_standby_feedback = on

# 日志设置
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_rotation_age = 1d
log_rotation_size = 1GB
log_min_duration_statement = 1000
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
log_autovacuum_min_duration = 0

# 监控设置
shared_preload_libraries = 'pg_stat_statements,pgaudit,pg_stat_monitor'
pg_stat_statements.track = all
track_io_timing = on
track_functions = all

# 自动维护
autovacuum = on
autovacuum_max_workers = 6
autovacuum_naptime = 30s
autovacuum_vacuum_threshold = 50
autovacuum_analyze_threshold = 50
autovacuum_vacuum_scale_factor = 0.1
autovacuum_analyze_scale_factor = 0.05
```

### C. 应急联系方式

```yaml
紧急联系人:
  DBA团队:
    主管: "张三 - 138-XXXX-XXXX"
    高级DBA: "李四 - 139-XXXX-XXXX"
    值班DBA: "400-XXX-XXXX"
    
  技术支持:
    PostgreSQL社区: "pgsql-general@postgresql.org"
    云服务商: "95187 (阿里云RDS支持)"
    
  供应商支持:
    硬件厂商: "400-XXX-XXXX"
    存储厂商: "400-XXX-XXXX"
```

---

**文档维护**: DBA团队  
**审核人**: 技术总监  
**下次更新**: 2025-08-12