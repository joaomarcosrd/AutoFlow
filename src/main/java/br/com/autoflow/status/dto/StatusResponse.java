package br.com.autoflow.status.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record StatusResponse(@JsonProperty("updated_at") String updatedAt, DependenciesStatus dependencies) {
    public record DependenciesStatus(DatabaseStatus database) {}

    public record DatabaseStatus(
            String version,
            @JsonProperty("max_connections") int maxConnections,
            @JsonProperty("opened_connections") int openedConnections) {}
}
