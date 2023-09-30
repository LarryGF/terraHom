# Applications

Below is a table with all of the applications included in the repo

| Name                    | Description                                                                                                           | Enabled by Default |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------|--------------------|
| media                   | Provides storage for media files (this just creates a Longhorn PV and PVC)                                            | false              |
| grafana                 | Monitoring and observability platform that integrates with Prometheus.                                                 | false              |
| kube-prometheus-stack   | Set of Grafana, Prometheus & Alertmanager for Kubernetes monitoring.                                                  | false              |
| kwatch                  | Kubernetes watcher that sends notifications to various platforms.                                                      | false              |
| loki                    | A horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus.                 | false              |
| promtail                | Agent for Loki, responsible for gathering logs and sending them to Loki.                                               | false              |
| authelia                | Single-sign-on and two-factor authentication server.                                                                  | true               |
| crowdsec                | Security automation tool that brings crowd-sourced threat intelligence to secure systems.                              | false              |
| dex                     | OpenID Connect (OIDC) and OAuth 2.0 identity and federation provider.                                                 | false              |
| sabnzbd                 | Binary newsreader which handles download from Usenet.                                                                 | true               |
| flood                   | Modern web UI for rTorrent with a Node.js backend and React frontend.                                                 | true               |
| nzbget                  | Efficient usenet downloader.                                                                                          | false              |
| plex                    | Media server platform that organizes video, music, and photos from personal media libraries and streams them to devices.| true               |
| jellyseerr              | Media server software to stream digital media.                                                                        | true               |
| tautulli                | Monitoring and tracking tool for Plex Media Server.                                                                   | false              |
| radarr                  | Movie collection manager for Usenet and BitTorrent users.                                                             | true               |
| sonarr                  | TV series management software for Usenet and BitTorrent users.                                                        | true               |
| prowlarr                | Central service for querying indexers and managing connections to trackers.                                           | true               |
| bazarr                  | Companion program to Sonarr and Radarr which manages and downloads subtitles.                                         | true               |
| readarr                 | Book, Magazine, and Comics collection manager for Usenet and BitTorrent users.                                        | false              |
| mylar                   | Automated Comic Book downloader (cbr/cbz) for Usenet and BitTorrent users.                                           | false              |
| homepage                | Central homepage or dashboard for services.                                                                           | true               |
| filebrowser             | Web file browser that allows managing files and directories from a web browser.                                       | true               |
| home-assistant          | Open source home automation platform.                                                                                 | false              |
| portainer               | GUI management tool for Docker and Kubernetes.                                                                       | false              |
| kubeview                | Web-based UI to visualize the topological relationships of resources within a Kubernetes cluster.                      | false              |
| renovate                | Automated dependency update tool that integrates with various platforms including GitHub.                              | false              |
