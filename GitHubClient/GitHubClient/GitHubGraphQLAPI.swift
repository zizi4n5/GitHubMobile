//  This file was automatically generated and should not be edited.

import Apollo

public final class SearchRepositoriesQuery: GraphQLQuery {
  public static let operationString =
    "query SearchRepositories($queryString: String!, $first: Int!, $after: String) {\n  search(query: $queryString, type: REPOSITORY, first: $first, after: $after) {\n    __typename\n    repositoryCount\n    edges {\n      __typename\n      node {\n        __typename\n        ... on Repository {\n          name\n          nameWithOwner\n          owner {\n            __typename\n            login\n            avatarUrl\n          }\n          shortDescriptionHTML\n          repositoryTopics(first: 100) {\n            __typename\n            edges {\n              __typename\n              node {\n                __typename\n                topic {\n                  __typename\n                  name\n                }\n              }\n            }\n          }\n          primaryLanguage {\n            __typename\n            name\n            color\n          }\n          stargazers {\n            __typename\n            totalCount\n          }\n          url\n          updatedAt\n        }\n      }\n      cursor\n    }\n    pageInfo {\n      __typename\n      endCursor\n      hasNextPage\n      hasPreviousPage\n      startCursor\n    }\n  }\n}"

  public var queryString: String
  public var first: Int
  public var after: String?

  public init(queryString: String, first: Int, after: String? = nil) {
    self.queryString = queryString
    self.first = first
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["queryString": queryString, "first": first, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["query": GraphQLVariable("queryString"), "type": "REPOSITORY", "first": GraphQLVariable("first"), "after": GraphQLVariable("after")], type: .nonNull(.object(Search.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(search: Search) {
      self.init(snapshot: ["__typename": "Query", "search": search.snapshot])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(snapshot: snapshot["search"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("repositoryCount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
        GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(repositoryCount: Int, edges: [Edge?]? = nil, pageInfo: PageInfo) {
        self.init(snapshot: ["__typename": "SearchResultItemConnection", "repositoryCount": repositoryCount, "edges": edges.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "pageInfo": pageInfo.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The number of repositories that matched the search query.
      public var repositoryCount: Int {
        get {
          return snapshot["repositoryCount"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "repositoryCount")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (snapshot["edges"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
        }
      }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(snapshot: snapshot["pageInfo"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "pageInfo")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
          GraphQLField("cursor", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(node: Node? = nil, cursor: String) {
          self.init(snapshot: ["__typename": "SearchResultItemEdge", "node": node.flatMap { $0.snapshot }, "cursor": cursor])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "node")
          }
        }

        /// A cursor for use in pagination.
        public var cursor: String {
          get {
            return snapshot["cursor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "cursor")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["Repository": AsRepository.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeIssue() -> Node {
            return Node(snapshot: ["__typename": "Issue"])
          }

          public static func makePullRequest() -> Node {
            return Node(snapshot: ["__typename": "PullRequest"])
          }

          public static func makeUser() -> Node {
            return Node(snapshot: ["__typename": "User"])
          }

          public static func makeOrganization() -> Node {
            return Node(snapshot: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(snapshot: ["__typename": "MarketplaceListing"])
          }

          public static func makeRepository(name: String, nameWithOwner: String, owner: AsRepository.Owner, shortDescriptionHtml: String, repositoryTopics: AsRepository.RepositoryTopic, primaryLanguage: AsRepository.PrimaryLanguage? = nil, stargazers: AsRepository.Stargazer, url: String, updatedAt: String) -> Node {
            return Node(snapshot: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "owner": owner.snapshot, "shortDescriptionHTML": shortDescriptionHtml, "repositoryTopics": repositoryTopics.snapshot, "primaryLanguage": primaryLanguage.flatMap { $0.snapshot }, "stargazers": stargazers.snapshot, "url": url, "updatedAt": updatedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asRepository: AsRepository? {
            get {
              if !AsRepository.possibleTypes.contains(__typename) { return nil }
              return AsRepository(snapshot: snapshot)
            }
            set {
              guard let newValue = newValue else { return }
              snapshot = newValue.snapshot
            }
          }

          public struct AsRepository: GraphQLSelectionSet {
            public static let possibleTypes = ["Repository"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
              GraphQLField("shortDescriptionHTML", type: .nonNull(.scalar(String.self))),
              GraphQLField("repositoryTopics", arguments: ["first": 100], type: .nonNull(.object(RepositoryTopic.selections))),
              GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
              GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(name: String, nameWithOwner: String, owner: Owner, shortDescriptionHtml: String, repositoryTopics: RepositoryTopic, primaryLanguage: PrimaryLanguage? = nil, stargazers: Stargazer, url: String, updatedAt: String) {
              self.init(snapshot: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "owner": owner.snapshot, "shortDescriptionHTML": shortDescriptionHtml, "repositoryTopics": repositoryTopics.snapshot, "primaryLanguage": primaryLanguage.flatMap { $0.snapshot }, "stargazers": stargazers.snapshot, "url": url, "updatedAt": updatedAt])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return snapshot["nameWithOwner"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "nameWithOwner")
              }
            }

            /// The User owner of the repository.
            public var owner: Owner {
              get {
                return Owner(snapshot: snapshot["owner"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "owner")
              }
            }

            /// A description of the repository, rendered to HTML without any links in it.
            public var shortDescriptionHtml: String {
              get {
                return snapshot["shortDescriptionHTML"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "shortDescriptionHTML")
              }
            }

            /// A list of applied repository-topic associations for this repository.
            public var repositoryTopics: RepositoryTopic {
              get {
                return RepositoryTopic(snapshot: snapshot["repositoryTopics"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "repositoryTopics")
              }
            }

            /// The primary language of the repository's code.
            public var primaryLanguage: PrimaryLanguage? {
              get {
                return (snapshot["primaryLanguage"] as? Snapshot).flatMap { PrimaryLanguage(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "primaryLanguage")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
              }
            }

            /// The HTTP URL for this repository
            public var url: String {
              get {
                return snapshot["url"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "url")
              }
            }

            /// Identifies the date and time when the object was last updated.
            @available(*, deprecated, message: "General type updated timestamps will eventually be replaced by other field specific timestamps.")
            public var updatedAt: String {
              get {
                return snapshot["updatedAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "updatedAt")
              }
            }

            public struct Owner: GraphQLSelectionSet {
              public static let possibleTypes = ["Organization", "User"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
                GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public static func makeOrganization(login: String, avatarUrl: String) -> Owner {
                return Owner(snapshot: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
              }

              public static func makeUser(login: String, avatarUrl: String) -> Owner {
                return Owner(snapshot: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The username used to login.
              public var login: String {
                get {
                  return snapshot["login"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "login")
                }
              }

              /// A URL pointing to the owner's public avatar.
              public var avatarUrl: String {
                get {
                  return snapshot["avatarUrl"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "avatarUrl")
                }
              }
            }

            public struct RepositoryTopic: GraphQLSelectionSet {
              public static let possibleTypes = ["RepositoryTopicConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("edges", type: .list(.object(Edge.selections))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(edges: [Edge?]? = nil) {
                self.init(snapshot: ["__typename": "RepositoryTopicConnection", "edges": edges.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// A list of edges.
              public var edges: [Edge?]? {
                get {
                  return (snapshot["edges"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes = ["RepositoryTopicEdge"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("node", type: .object(Node.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(node: Node? = nil) {
                  self.init(snapshot: ["__typename": "RepositoryTopicEdge", "node": node.flatMap { $0.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge.
                public var node: Node? {
                  get {
                    return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes = ["RepositoryTopic"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("topic", type: .nonNull(.object(Topic.selections))),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(topic: Topic) {
                    self.init(snapshot: ["__typename": "RepositoryTopic", "topic": topic.snapshot])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The topic.
                  public var topic: Topic {
                    get {
                      return Topic(snapshot: snapshot["topic"]! as! Snapshot)
                    }
                    set {
                      snapshot.updateValue(newValue.snapshot, forKey: "topic")
                    }
                  }

                  public struct Topic: GraphQLSelectionSet {
                    public static let possibleTypes = ["Topic"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(name: String) {
                      self.init(snapshot: ["__typename": "Topic", "name": name])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The topic's name.
                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }
                  }
                }
              }
            }

            public struct PrimaryLanguage: GraphQLSelectionSet {
              public static let possibleTypes = ["Language"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("color", type: .scalar(String.self)),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(name: String, color: String? = nil) {
                self.init(snapshot: ["__typename": "Language", "name": name, "color": color])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The name of the current language.
              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }

              /// The color defined for the current language.
              public var color: String? {
                get {
                  return snapshot["color"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "color")
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes = ["StargazerConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes = ["PageInfo"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("endCursor", type: .scalar(String.self)),
          GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("hasPreviousPage", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("startCursor", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(endCursor: String? = nil, hasNextPage: Bool, hasPreviousPage: Bool, startCursor: String? = nil) {
          self.init(snapshot: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage, "hasPreviousPage": hasPreviousPage, "startCursor": startCursor])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? {
          get {
            return snapshot["endCursor"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endCursor")
          }
        }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool {
          get {
            return snapshot["hasNextPage"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "hasNextPage")
          }
        }

        /// When paginating backwards, are there more items?
        public var hasPreviousPage: Bool {
          get {
            return snapshot["hasPreviousPage"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "hasPreviousPage")
          }
        }

        /// When paginating backwards, the cursor to continue.
        public var startCursor: String? {
          get {
            return snapshot["startCursor"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "startCursor")
          }
        }
      }
    }
  }
}