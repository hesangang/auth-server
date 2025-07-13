
CREATE TABLE oauth2_registered_client (
                                          id VARCHAR(100) PRIMARY KEY,
                                          client_id VARCHAR(100) NOT NULL,
                                          client_id_issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                          client_secret VARCHAR(200),
                                          client_secret_expires_at TIMESTAMP NULL,
                                          client_name VARCHAR(200) NOT NULL,
                                          client_authentication_methods VARCHAR(1000) NOT NULL,
                                          authorization_grant_types VARCHAR(1000) NOT NULL,
                                          redirect_uris VARCHAR(1000),
                                          post_logout_redirect_uris VARCHAR(1000),
                                          scopes VARCHAR(1000) NOT NULL,
                                          client_settings VARCHAR(2000) NOT NULL,
                                          token_settings VARCHAR(2000) NOT NULL
);
CREATE UNIQUE INDEX idx_client_id ON oauth2_registered_client (client_id);

CREATE TABLE oauth2_authorization (
                                      id VARCHAR(100) PRIMARY KEY,
                                      registered_client_id VARCHAR(100) NOT NULL,
                                      principal_name VARCHAR(200) NOT NULL,
                                      authorization_grant_type VARCHAR(100) NOT NULL,
                                      authorized_scopes VARCHAR(1000),
                                      attributes TEXT,
                                      state VARCHAR(500),
                                      authorization_code_value TEXT,
                                      authorization_code_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      authorization_code_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      authorization_code_metadata TEXT,
                                      access_token_value TEXT,
                                      access_token_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      access_token_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      access_token_metadata TEXT,
                                      access_token_type VARCHAR(100),
                                      access_token_scopes VARCHAR(1000),
                                      refresh_token_value TEXT,
                                      refresh_token_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      refresh_token_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      refresh_token_metadata TEXT,
                                      id_token_value TEXT,
                                      id_token_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      id_token_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      id_token_metadata TEXT,
                                      oidc_id_token_value TEXT,
                                      oidc_id_token_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      oidc_id_token_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      oidc_id_token_metadata TEXT,
                                      user_code_value TEXT,
                                      user_code_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      user_code_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      user_code_metadata TEXT,
                                      device_code_value TEXT,
                                      device_code_issued_at TIMESTAMP NULL DEFAULT NULL,
                                      device_code_expires_at TIMESTAMP NULL DEFAULT NULL,
                                      device_code_metadata TEXT
);


CREATE TABLE oauth2_authorization_consent (
                                              registered_client_id VARCHAR(100) NOT NULL,
                                              principal_name VARCHAR(200) NOT NULL,
                                              authorities VARCHAR(1000) NOT NULL,
                                              PRIMARY KEY (registered_client_id, principal_name)
);

