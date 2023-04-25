# Post Install

These are the steps you need to follow after you've finished the infrastructure deployment  to configure some of the services.

## Table of contents

- [Post Install](#post-install)
  - [Table of contents](#table-of-contents)
  - [Rtorrent-Flood](#rtorrent-flood)
  - [Jackett (DEPRECATED)](#jackett-deprecated)
  - [Prowlarr](#prowlarr)
  - [Sonarr/Radarr](#sonarrradarr)
  - [Plex/Ombi](#plexombi)
  - [orvpn wireguar](#orvpn-wireguar)
  - [Home assistant](#home-assistant)
  - [Mylar](#mylar)
  - [Jellyfin](#jellyfin)
    - [Plugins](#plugins)

## Rtorrent-Flood

- Go to <https://rtorrent.{your> domain}.duckdns.org
- Create username and password and keep them in mind, you will need them later
- Paste the following path in the socket `/config/.local/share/rtorrent/rtorrent.sock/config/.local/share/rtorrent/rtorrent.sock`

## Jackett (DEPRECATED)

- __Jackett has been deprecated in favor of prowlarr, it is way easier to sync the indexers that way__
- Go to `https://jackett.{your domain}.duckdns.org/UI/Dashboard`
- Add your desired indexers
- Don't close the page yet, since you'll need it to add indexers to Sonarr/Radarr

## Prowlarr

- Go to `https://prowlar.{your> domain}.duckdns.org`

- Add your desired indexers

  - Go to the apps (#sonarr/radarr) and get their API keys by going to Settings -> General -> Security

- Go to Settings -> Apps and add your deployed apps:

  - For all apps `Prowlar server` will be: `http://prowlar:9696`

    - For all apps the `App server` will be the name of the app, and you should get the port from the table below table:

    | Service         | Port |
    | --------------- | ---- |
    | radarr          | 7878 |
    | sonarr          | 8989 |
    | whisparr-radarr | 6969 |

  - For instance, for `sonarr`, `App server` would be `http://sonarr:8989`

- After you've finished adding the apps you might want to trigger a `Sync app indexers`

## [Sonarr/Radarr](https://wiki.servarr.com/radarr)

- Go to Radarr/Sonarr:  `https://{radarr/sonarr}.{your domain}.duckdns.org`
- Go to Settings -> Media Management: set root folder to /downloads, that's where the `media`shared volume will be mounted
- Go to Settings -> Download Clients: Add a new `Flood` downloader:
  - Name: Flood
  - Host: `rtorrent-rtorrent-flood`
  - Port: `3000`
  - Set username and password from [Flood](#rtorrent-flood) step

- Add new profiles to support other languages

- If the categories don't match between Radarr/Sonarr and Prowlarr it might fail silently

## Plex/Ombi

- Login to Plex by visiting: `https://plex.{your domain}.duckdns.org`

emby-> settings-> api key

ombi emby

## orvpn wireguar

<https://gist.github.com/bluewalk/7b3db071c488c82c604baf76a42eaad3>
<https://github.com/sfiorini/NordVPN-Wireguard>

## Home assistant

Go to Settings > Devices & Services and then click the Add Integration button.
Use the search bar to look for "hacs". Click on HACS.
Check everything (it’s optional) and click Submit.
You will see a code. Note it down or copy it and click on the URL displayed.
Sign in to your GitHub profile and paste or type the code. Click Continue.
Click the Authorize HACS button.

## Mylar

set comics foler and comicvine api key
enable api key for prowlarr

## Jellyfin

### Plugins

https://github.com/nicknsy/jellyscrub