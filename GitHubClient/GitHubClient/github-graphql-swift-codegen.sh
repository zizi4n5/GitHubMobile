#/bin/bash!
rm -f GitHubGraphQLSchema.json GitHubGraphQLAPI.swift
apollo-codegen download-schema https://api.github.com/graphql --header "Authorization: Bearer f8cf3573a35ce4807a525348215c72d3a29e3bbe" --output GitHubGraphQLSchema.json
apollo-codegen generate GitHubGraphQLAPI.graphql --schema GitHubGraphQLSchema.json --output GitHubGraphQLAPI.swift

