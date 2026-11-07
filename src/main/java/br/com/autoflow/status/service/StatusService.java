package br.com.autoflow.status.service;

import br.com.autoflow.status.dto.StatusResponse;
import br.com.autoflow.status.dto.StatusResponse.DatabaseStatus;
import br.com.autoflow.status.dto.StatusResponse.DependenciesStatus;
import java.time.Instant;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StatusService {

    private final JdbcTemplate jdbcTemplate;

    @Value("${app.database.name:postgres}")
    private String databaseName;

    public StatusResponse consultarStatusBanco() {
        String updatedAt = Instant.now().toString();

        String version = jdbcTemplate.queryForObject("SHOW server_version;", String.class);

        String maxConnectionsStr = jdbcTemplate.queryForObject("SHOW max_connections;", String.class);
        int maxConnections = maxConnectionsStr != null ? Integer.parseInt(maxConnectionsStr) : 0;

        Integer openedConnections = jdbcTemplate.queryForObject(
                "SELECT count(*)::int FROM pg_stat_activity WHERE datname = ?;", Integer.class, databaseName);

        DatabaseStatus dbStatus =
                new DatabaseStatus(version, maxConnections, openedConnections != null ? openedConnections : 0);

        return new StatusResponse(updatedAt, new DependenciesStatus(dbStatus));
    }
}
