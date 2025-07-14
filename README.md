# 认证中心
# 🛡️ OAuth2 + OpenID Connect 客户端接入指南（message）

本项目使用 Spring Authorization Server 构建认证中心，客户端 `message` 支持以下授权方式：

- `authorization_code`
- `refresh_token`
- `client_credentials`

---

## ✅ 客户端注册信息

| 字段 | 值 |
|------|----|
| client_id | `message` |
| client_secret | `123456` |
| redirect_uri | `http://localhost:8080/message/auth/login/oauth2/code/message` |
| post_logout_redirect_uri | `http://localhost:8080/message/auth/logout` |
| 授权方式 | `authorization_code`, `refresh_token`, `client_credentials` |
| scopes | `openid`, `read`, `write` |
| ID | `msg-001` |

---

## 📡 授权服务器地址

http://localhost:9000

### 支持的端点：

| 功能 | 路径 |
|------|------|
| 授权端点 | `/oauth2/authorize` |
| Token 端点 | `/oauth2/token` |
| 用户信息 | `/userinfo` |
| OpenID 探针 | `/.well-known/openid-configuration` |
| JWK 公钥 | `/.well-known/jwks.json` |
| 退出登录 | `/logout?post_logout_redirect_uri=http://localhost:8080/message/auth/logout` |

---

## 🔐 授权码流程（Authorization Code）

### 第一步：浏览器请求授权码

访问以下 URL：

http://localhost:9000/oauth2/authorize?response_type=code&client_id=message&redirect_uri=http://localhost:8080/message/auth/login/oauth2/code/message&scope=openid read write&state=xyz


> 登录账号：如 `admin` / `admin123`

### 第二步：跳转回客户端

浏览器将跳转至：

http://localhost:8080/message/auth/login/oauth2/code/message?code=xxxxx&state=xyz


---

### 第三步：客户端通过授权码换取 Token

```http
POST http://localhost:9000/oauth2/token
Authorization: Basic base64(message:123456)
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
code=xxxxx&
redirect_uri=http://localhost:8080/message/auth/login/oauth2/code/message
```
返回：
```json
{
  "access_token": "xxx",
  "refresh_token": "yyy",
  "id_token": "zzz",
  "token_type": "Bearer",
  "expires_in": 300,
  "scope": "openid read write"
}
```

🔁 Refresh Token 流程

```http request
POST http://localhost:9000/oauth2/token
Authorization: Basic base64(message:123456)
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&
refresh_token=your_refresh_token

```
🤖 Client Credentials 模式（无需用户登录）

```http request
POST http://localhost:9000/oauth2/token
Authorization: Basic base64(message:123456)
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
scope=read

```

👤 获取用户信息

```http request
GET http://localhost:9000/userinfo
Authorization: Bearer <access_token>

```

🕒 Token 有效期配置

| Token 类型      | TTL   |
| ------------- | ----- |
| 授权码           | 5 分钟  |
| Access Token  | 5 分钟  |
| Refresh Token | 1 小时  |
| ID Token 签名算法 | RS256 |

🚪 退出登录（OpenID 回跳）

GET http://localhost:9000/logout?post_logout_redirect_uri=http://localhost:8080/message/auth/logout

⚙️ Spring Boot 客户端配置（application.yml）

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          message:
            client-id: message
            client-secret: 123456
            scope: openid,read,write
            redirect-uri: "{baseUrl}/message/auth/login/oauth2/code/{registrationId}"
            authorization-grant-type: authorization_code
        provider:
          message:
            authorization-uri: http://localhost:9000/oauth2/authorize
            token-uri: http://localhost:9000/oauth2/token
            user-info-uri: http://localhost:9000/userinfo
            user-name-attribute: sub

```

👥 测试用户配置（示例）

```java
@Bean
public UserDetailsService userDetailsService() {
    return new InMemoryUserDetailsManager(
        User.withUsername("admin")
            .password("{noop}admin123")
            .roles("USER")
            .build()
    );
}

```

📚 参考链接
- Spring Authorization Server: https://github.com/spring-projects/spring-authorization-server
- OAuth2.1 / OIDC: https://openid.net/connect/
- Spring Security OAuth2 客户端: https://docs.spring.io/spring-security/reference/servlet/oauth2/client/index.html

# ✅ 如何正确传 client_id 和 client_secret（三种方式）
- 以下任选其一，但不能混用错位置。

## ✅ 方式 1：使用 HTTP Basic Auth（推荐，Spring 默认）

Postman 设置：
- Authorization → 类型选择 Basic Auth

- 输入：
Username = client_id（比如 message）
Password = client_secret（比如 123456）
这会自动添加请求头：
```http request
Authorization: Basic base64(client_id:client_secret)
```

## ✅ 方式 2：用表单参数（x-www-form-urlencoded）
```http request
POST /oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
code=xxx
client_id=message
client_secret=123456
...

```
适用于客户端认证方式是 client_secret_post。

## ✅ 方式 3：公共客户端（不传 secret）→ 设置为 none
适合 SPA、小程序等前端应用，数据库配置必须如下：
- client_authentication_methods = none
- require-proof-key = true
  
此时请求 /oauth2/token 时：
```http request
grant_type=authorization_code
client_id=message
code=xxx
redirect_uri=...
code_verifier=...

```
不传 client_secret，不会报 invalid_client。

## ✅ 总结
| 使用方式                                                | client\_secret 必须传？ | 推荐场景              |
| --------------------------------------------------- | ------------------- | ----------------- |
| Basic Auth (client\_secret\_basic)                  | ✅ 必须                | 后端服务、可信客户端        |
| Form 表单参数 (client\_secret\_post)                    | ✅ 必须                | 非浏览器或 CLI 客户端     |
| Public 客户端 (client\_authentication\_methods = none) | ❌ 不需要               | 前端、SPA、小程序 + PKCE |
