CREATE TABLE IDN_BASE_TABLE (
            PRODUCT_NAME VARCHAR (20) NOT NULL,
            PRIMARY KEY (PRODUCT_NAME))
/
INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server')
/
CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
            CONSUMER_KEY VARCHAR (512) NOT NULL,
            CONSUMER_SECRET VARCHAR (512),
            USERNAME VARCHAR (255),
            TENANT_ID INTEGER DEFAULT 0,
            APP_NAME VARCHAR (255),
            OAUTH_VERSION VARCHAR (128),
            CALLBACK_URL VARCHAR (1024),
            GRANT_TYPES VARCHAR (1024),
            PRIMARY KEY (CONSUMER_KEY))
/
CREATE TABLE IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN VARCHAR (512) NOT NULL,
            REQUEST_TOKEN_SECRET VARCHAR (512),
            CONSUMER_KEY VARCHAR (512),
            CALLBACK_URL VARCHAR (1024),
            SCOPE VARCHAR(2048),
            AUTHORIZED VARCHAR (128),
            OAUTH_VERIFIER VARCHAR (512),
            AUTHZ_USER VARCHAR (512),
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE)
/
CREATE TABLE IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN VARCHAR (512) NOT NULL,
            ACCESS_TOKEN_SECRET VARCHAR (512),
            CONSUMER_KEY VARCHAR (512),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR (512),
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE)
/
CREATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE (
            AUTHORIZATION_CODE VARCHAR (512) NOT NULL,
            CONSUMER_KEY VARCHAR (512),
	    CALLBACK_URL VARCHAR (1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR (512),
            TIME_CREATED TIMESTAMP,
            VALIDITY_PERIOD BIGINT,
            PRIMARY KEY (AUTHORIZATION_CODE),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE)
/
CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN (
			ACCESS_TOKEN VARCHAR (255) NOT NULL,
			REFRESH_TOKEN VARCHAR (255),
			CONSUMER_KEY VARCHAR (255) NOT NULL,
			AUTHZ_USER VARCHAR (255) NOT NULL,
			USER_TYPE VARCHAR (25) NOT NULL,
			TIME_CREATED TIMESTAMP,
			VALIDITY_PERIOD BIGINT,
			TOKEN_SCOPE VARCHAR (2048),
			TOKEN_STATE VARCHAR (25) DEFAULT 'ACTIVE' NOT NULL,
			TOKEN_STATE_ID VARCHAR (256) DEFAULT 'NONE' NOT NULL,
			PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE,
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY, AUTHZ_USER,USER_TYPE,TOKEN_STATE,TOKEN_STATE_ID))
/
CREATE TABLE IDN_OAUTH2_SCOPE (
  SCOPE_ID INTEGER NOT NULL,
  SCOPE_KEY VARCHAR (100) NOT NULL,
  NAME VARCHAR (255) NULL,
  DESCRIPTION VARCHAR (512) NULL,
  TENANT_ID INTEGER DEFAULT 0 NOT NULL,
  PRIMARY KEY (SCOPE_ID))
/
CREATE SEQUENCE IDN_OAUTH2_SCOPE_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_OAUTH2_SCOPE_TRIGGER NO CASCADE BEFORE INSERT ON IDN_OAUTH2_SCOPE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.SCOPE_ID)
       = (NEXTVAL FOR IDN_OAUTH2_SCOPE_SEQUENCE);

END/
CREATE TABLE IDN_OAUTH2_RESOURCE_SCOPE (
  "RESOURCE" VARCHAR (255) NOT NULL,
  SCOPE_ID INTEGER NOT NULL,
  PRIMARY KEY ("RESOURCE"),
  FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID))
/
CREATE TABLE UM_USER_ATTRIBUTES (
                    ID INTEGER NOT NULL,
                    ATTR_NAME VARCHAR(255) NOT NULL,
                    ATTR_VALUE VARCHAR(255),
                    USER_ID INTEGER,
                    --FOREIGN KEY (USER_ID) REFERENCES UM_USER(UM_ID) ON DELETE CASCADE,
                    PRIMARY KEY (ID))
/
CREATE TABLE IDN_SCIM_GROUP (
			ID INTEGER NOT NULL,
			TENANT_ID INTEGER NOT NULL,
			ROLE_NAME VARCHAR(255) NOT NULL,
            ATTR_NAME VARCHAR(1024) NOT NULL,
			ATTR_VALUE VARCHAR(1024),
            PRIMARY KEY (ID))
/
CREATE SEQUENCE IDN_SCIM_GROUP_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_SCIM_GROUP_TRIGGER NO CASCADE BEFORE INSERT ON IDN_SCIM_GROUP
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_SCIM_GROUP_SEQUENCE);

END/
CREATE TABLE IDN_SCIM_PROVIDER (
            CONSUMER_ID VARCHAR(255) NOT NULL,
            PROVIDER_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            USER_PASSWORD VARCHAR(255) NOT NULL,
            USER_URL VARCHAR(1024) NOT NULL,
			GROUP_URL VARCHAR(1024),
			BULK_URL VARCHAR(1024),
            PRIMARY KEY (CONSUMER_ID,PROVIDER_ID))
/
CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT 0 NOT NULL,
            COOKIE_VALUE VARCHAR(1024),
            CREATED_TIME TIMESTAMP,
            PRIMARY KEY (USER_NAME, TENANT_ID))
/
CREATE TABLE IDN_OPENID_USER_RPS (
			USER_NAME VARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0 NOT NULL,
			RP_URL VARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL))
/
CREATE TABLE IDN_OPENID_ASSOCIATIONS (
			HANDLE VARCHAR(255) NOT NULL,
			ASSOC_TYPE VARCHAR(255) NOT NULL,
			EXPIRE_IN TIMESTAMP NOT NULL,
			MAC_KEY VARCHAR(255) NOT NULL,
			ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
			PRIMARY KEY (HANDLE))
/
CREATE TABLE IDN_STS_STORE (
                        ID INTEGER NOT NULL,
                        TOKEN_ID VARCHAR(255) NOT NULL,
                        TOKEN_CONTENT BLOB NOT NULL,
                        CREATE_DATE TIMESTAMP NOT NULL,
                        EXPIRE_DATE TIMESTAMP NOT NULL,
                        STATE INTEGER DEFAULT 0,
                        PRIMARY KEY (ID))
/
CREATE SEQUENCE IDN_STS_STORE_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_STS_STORE_TRIGGER NO CASCADE BEFORE INSERT ON IDN_STS_STORE
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_STS_STORE_SEQUENCE);

END
/
CREATE TABLE IDN_IDENTITY_USER_DATA (
                        TENANT_ID INTEGER DEFAULT -1234 NOT NULL,
                        USER_NAME VARCHAR(255) NOT NULL,
                        DATA_KEY VARCHAR(255) NOT NULL,
                        DATA_VALUE VARCHAR(255) NOT NULL,
                        PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY))
/
CREATE TABLE IDN_IDENTITY_META_DATA (
                        USER_NAME VARCHAR(255) NOT NULL,
                        TENANT_ID INTEGER DEFAULT -1234 NOT NULL,
                        METADATA_TYPE VARCHAR(255) NOT NULL,
                        METADATA VARCHAR(255) NOT NULL,
                        VALID VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA))
/
CREATE TABLE IDN_THRIFT_SESSION (
                 SESSION_ID VARCHAR(255) NOT NULL,
                 USER_NAME VARCHAR(255) NOT NULL,
                 CREATED_TIME VARCHAR(255) NOT NULL,
                 LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
                 PRIMARY KEY (SESSION_ID)
)
/
CREATE TABLE IDN_APPMGT_APP (
            ID INTEGER NOT NULL,
	    APP_NAME VARCHAR (255) NOT NULL ,
            USERNAME VARCHAR (255) NOT NULL ,
            TENANT_ID INTEGER NOT NULL,
	    USER_STORE VARCHAR (255) NOT NULL,
	    ROLE_CLAIM VARCHAR (512),
      PRIMARY KEY (ID)
)
/
CREATE SEQUENCE IDN_APPMGT_APP_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_APPMGT_APP_TRIGGER NO CASCADE BEFORE INSERT ON IDN_APPMGT_APP
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_APPMGT_APP_SEQUENCE);

END
/
ALTER TABLE IDN_APPMGT_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID)
/
CREATE TABLE IDN_APPMGT_CLIENT (
            ID INTEGER NOT NULL,
            CLIENT_ID VARCHAR (512) NOT NULL,
	    CLIENT_SECRETE VARCHAR (512),
	    TENANT_ID INTEGER NOT NULL,
            CLIENT_TYPE VARCHAR (255) NOT NULL ,
	    APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)
/
CREATE SEQUENCE IDN_APPMGT_CLIENT_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_APPMGT_CLIENT_TRIGGER NO CASCADE BEFORE INSERT ON IDN_APPMGT_CLIENT
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_APPMGT_CLIENT_SEQUENCE);

END
/
ALTER TABLE IDN_APPMGT_CLIENT ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES IDN_APPMGT_APP (ID) ON DELETE CASCADE
/
CREATE TABLE IDN_APPMGT_STEP (
            ID INTEGER NOT NULL,
	    STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL ,
            PRIMARY KEY (ID)
)
/
CREATE SEQUENCE IDN_APPMGT_STEP_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_APPMGT_STEP_TRIGGER NO CASCADE BEFORE INSERT ON IDN_APPMGT_STEP
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_APPMGT_STEP_SEQUENCE);

END
/
ALTER TABLE IDN_APPMGT_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES IDN_APPMGT_APP (ID) ON DELETE CASCADE
/
CREATE TABLE IDN_APPMGT_STEP_IDP (
            STEP_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL,
	    AUTHENTICATOR_NAME VARCHAR (255) NOT NULL,
            PRIMARY KEY (STEP_ID, IDP_NAME, AUTHENTICATOR_NAME)
)
/
ALTER TABLE IDN_APPMGT_STEP_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (STEP_ID) REFERENCES IDN_APPMGT_STEP (ID) ON DELETE CASCADE
/
CREATE TABLE IDN_APPMGT_CLAIM_MAPPING (
	    ID INTEGER NOT NULL,
	    IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
	    APP_ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)
/
CREATE SEQUENCE IDN_APMGT_CLAIM_MAP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_APMGT_CLAIM_MAP_TRG NO CASCADE BEFORE INSERT ON IDN_APPMGT_CLAIM_MAPPING
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_APMGT_CLAIM_MAP_SEQ);

END
/
ALTER TABLE IDN_APPMGT_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES IDN_APPMGT_APP (ID) ON DELETE CASCADE
/
CREATE TABLE IDN_APPMGT_ROLE_MAPPING (
	    ID INTEGER NOT NULL,
	    IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
	    APP_ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            PRIMARY KEY (ID)
)
/
CREATE SEQUENCE IDN_APMGT_ROLE_MAP_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE TRIGGER IDN_APMGT_ROLE_MAP_SEQ_TRG NO CASCADE BEFORE INSERT ON IDN_APPMGT_ROLE_MAPPING
REFERENCING NEW AS NEW FOR EACH ROW MODE DB2SQL

BEGIN ATOMIC

    SET (NEW.ID)
       = (NEXTVAL FOR IDN_APMGT_ROLE_MAP_SEQ);

END
/
ALTER TABLE IDN_APPMGT_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES IDN_APPMGT_APP (ID) ON DELETE CASCADE
/