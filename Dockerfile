## Builds a keycloak image
FROM quay.io/keycloak/keycloak:21.1 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_HTTP_RELATIVE_PATH=/kc
ENV KC_FEATURES=preview

# Configure a database vendor
ENV KC_DB=postgres

# build keycloak
WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:21.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY ./exports /opt/keycloak/data/import

# Enable default admin
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]