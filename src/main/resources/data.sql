insert into oauth2_registered_client (
  id, client_id, client_id_issued_at, client_secret, client_secret_expires_at, client_name,
  client_authentication_methods, authorization_grant_types, redirect_uris, post_logout_redirect_uris,
  scopes, client_settings, token_settings
) values (
  'client-001',
  'client-app',
  CURRENT_TIMESTAMP,
  '{noop}123456',
  NULL,
  '客户端应用',
  'client_secret_basic',
  'authorization_code,refresh_token,client_credentials',
  'http://localhost:8080/login/oauth2/code/client-app',
  'http://localhost:8080/logout',
  'openid,read,write',
  '{"@class":"java.util.HashMap","settings.client.require-authorization-consent":false,"settings.client.require-proof-key":false}',
  '{"@class":"java.util.HashMap","settings.token.authorization-code-time-to-live":["java.time.Duration","PT5M"],"settings.token.access-token-time-to-live":["java.time.Duration","PT5M"],"settings.token.refresh-token-time-to-live":["java.time.Duration","PT1H"],"settings.token.id-token-signature-algorithm":["org.springframework.security.oauth2.jose.jws.SignatureAlgorithm","RS256"]}'
);

insert into oauth2_registered_client (
    id, client_id, client_id_issued_at, client_secret, client_secret_expires_at, client_name,
    client_authentication_methods, authorization_grant_types, redirect_uris, post_logout_redirect_uris,
    scopes, client_settings, token_settings
) values (
    'msg-001',
    'message',
    CURRENT_TIMESTAMP,
    '{noop}123456',
    NULL,
    '消息应用',
    'client_secret_basic',
    'authorization_code,refresh_token,client_credentials',
    'http://localhost:8080/message/auth/login/oauth2/code/message',
    'http://localhost:8080/message/auth/logout',
    'openid,read,write',
    '{"@class":"java.util.HashMap","settings.client.require-authorization-consent":false,"settings.client.require-proof-key":false}',
    '{"@class":"java.util.HashMap","settings.token.authorization-code-time-to-live":["java.time.Duration","PT5M"],"settings.token.access-token-time-to-live":["java.time.Duration","PT5M"],"settings.token.refresh-token-time-to-live":["java.time.Duration","PT1H"],"settings.token.id-token-signature-algorithm":["org.springframework.security.oauth2.jose.jws.SignatureAlgorithm","RS256"]}'
);
