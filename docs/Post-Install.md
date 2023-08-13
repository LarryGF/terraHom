# Post Install

These are the steps you need to follow after you've finished the infrastructure deployment  to configure some of the services.

## Table of contents

- [Post Install](#post-install)
  - [Table of contents](#table-of-contents)
  - [Rtorrent-Flood](#rtorrent-flood)
  - [Jackett (DEPRECATED)](#jackett-deprecated)
  - [IMPORTANT INFORMATION FOR \*ARR](#important-information-for-arr)
  - [Prowlarr](#prowlarr)
  - [Sonarr/Radarr](#sonarrradarr)
  - [Plex/Ombi](#plexombi)
  - [Nordvpn wireguard](#nordvpn-wireguard)
  - [Home assistant](#home-assistant)
  - [Mylar](#mylar)
  - [Jellyfin](#jellyfin)
    - [Plugins](#plugins)
  - [Jellyseerr](#jellyseerr)
  - [Duplicati](#duplicati)
  - [Authelia](#authelia)
    - [Setting encryption keys](#setting-encryption-keys)

## Rtorrent-Flood

- Go to <https://rtorrent.{your> domain}.duckdns.org
- Create username and password and keep them in mind, you will need them later
- Paste the following path in the socket `/config/.local/share/rtorrent/rtorrent.sock/config/.local/share/rtorrent/rtorrent.sock`

## Jackett (DEPRECATED)

- __Jackett has been deprecated in favor of prowlarr, it is way easier to sync the indexers that way__
- Go to `https://jackett.{your domain}.duckdns.org/UI/Dashboard`
- Add your desired indexers
- Don't close the page yet, since you'll need it to add indexers to Sonarr/Radarr

## IMPORTANT INFORMATION FOR *ARR

Please bear in mind that, after you have configured `Radarr,Sonarr,Prowlarr` etc. they will generate an API key that you will use to configure the integration between the services, if you're just interested in making the services work, that's as far as you'd need to go, but there are additional steps if you want the homepage widgets to work.

- Take note of the API key for each service
- Add it to `terraform.tfvars` under the `api_keys` variable, it should look something like this:

```hcl
api_keys = {
    radarr_key = "radarr-key"
    sonarr_key = "sonarr-key"
    prowlarr_key = "prowlarr-key"
    plex_key = "plex-key"

}
```

- Then you have to run again the applications' stack:

```shell
terraform apply -auto-approve -target module.argocd_application
```

## Prowlarr

- Go to `https://prowlar.{your> domain}.duckdns.org`

- I don't recommend you set up auth for this, it might lock you out of the app, and it's not worth the hassle
- Add your desired indexers

  - Go to the apps (#sonarr/radarr) and get their API keys by going to Settings -> General -> Security

- Go to Settings -> Apps and add your deployed apps:

  - For all apps `Prowlar server` will be: `http://prowlarr:9696`

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
  - Host: `flood-rtorrent-flood`
  - Port: `3000`
  - Set username and password from [Flood](#rtorrent-flood) step

- Add new profiles to support other languages

- If the categories don't match between Radarr/Sonarr and Prowlarr it might fail silently

## Plex/Ombi

- Login to Plex by visiting: `https://plex.{your domain}.duckdns.org`

emby-> settings-> api key

ombi emby

## Nordvpn wireguard

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

[jellyscrub](https://github.com/nicknsy/jellyscrub)

## Jellyseerr

- You need to select `Use your Jellyfin account`
- Then, for the url: `http://jellyfin:8096`
- Use your previously created Jellyfin account
- Add `Radarr` and `Sonarr` in the same way as you did with [Prowlarr](#prowlarr)
- Make sure to `test` first so you have access to the quality profiles
- Set the root folder
- Don't forget to mark them as default

## Duplicati

I chose to go with OneDrive as a backup solution, since it's free and it's easy to setup, also, if you have 2FA enabled in Mega it won't work, and it's not worth the risk to disable it. Haven't tried other solutions but this one works fine.

- Follow [these steps](https://forum.Duplicati.com/t/setting-up-onedrive-personal/588)
- If you click on `Test connection` and doesn't work, don't stress about it, it's probably a Duplicati thing, this doesn't necessarily means it won't work
- Once you've finished your configuration, run it and verify everything is working
- To speed the process up, export that manual config and download it somewhere handy, you will have a `json` file somewhat similar to this:
  
  ```shell
    ...
    "CreatedByVersion": "2.0.6.3",
    "Schedule": {
      "ID": 1,
      "Tags": [
        "ID=3"
      ],
      "Repeat": "1D",
      "Rule": "AllowedWeekDays=Monday,Sunday",
      "AllowedDays": [
        "mon",
        "sun"
      ]
    },
    "Backup": {
      "ID": "3",
      "Name": "Sonarr",
      "Description": "",
      ...
      "TargetURL": "onedrivev2:///Duplicati/sonarr/(...)",
    "Sources": [
      "/config/sonarr/"
    ],
    ...
    "DisplayNames": {
    "/config/sonarr/": "sonarr"
  }
    } 
  ```

- Since the only thing that should be different is the base path and the destination path, you can just quickly edit that same file and keep reuploading it to Duplicati until you have all your services backed up
- All of the config folders for your services are mounted under `/config` in Duplicati by default
- Of course, you can alway be lazy and backup the entire /config folder, Duplicati config included, but you will loose graularity and control (although you might want to backup it etirely anyways in case Duplicati itself goes down)

## Authelia

### Setting encryption keys

Before installation put some long, random values under:

```hcl
api_keys = {
    ...
    authelia_JWT_TOKEN = "unique_long_string"
    authelia_SESSION_ENCRYPTION_KEY = "unique_long_string"
    authelia_STORAGE_ENCRYPTION_KEY = "unique_long_string"
}
```

