import os
import json

MODULES_TO_RUN = os.getenv("MODULES_TO_RUN",False)
COMMON_CONFIG = os.getenv("COMMON_CONFIG",False)
MESSAGE = os.getenv("MESSAGE",False)
DOMAIN = os.getenv("DOMAIN",False)
modules = json.loads(MODULES_TO_RUN)
common = json.loads(COMMON_CONFIG)
message = json.loads(MESSAGE)
service_to_categories = {
    "duckdns": "internal-services",
    "adguard": "internal-services",
    "grafana": "internal-services",
    "heimdall": "public-services",
    "qbittorrent": "public-services",
    "home-assistant": "public-services",
    "filebrowser": "public-services",
    "mylar": "public-services",
    "readarr": "public-services",
    "prowlarr": "public-services",
    "jellyseerr": "media",
    "whisparr": "media",
    "radarr": "media",
    "sonarr": "media",
    "bazarr": "media",
    "jellyfin": "media"
}

# categories = {}
# for service, category in service_to_categories.items():
#     if category not in categories:
#         categories[category] = [service]
#     else:
#         categories[category].append(service)

categories = set(service_to_categories.values())
services = {category:{
    "name": category.replace("-", " ").title(),
    "icon": "fas fa-code-branch",
    "items": []
} for category in categories}
print(services)
####

# with open('common.json', 'w') as outfile:
#     json.dump(common, outfile,indent=2)
# with open('message.json', 'w') as outfile:
#     json.dump(message, outfile,indent=2)
# with open('modules.json', 'w') as outfile:
#     json.dump(modules, outfile,indent=2)
####

###
# with open('common.json', 'r') as outfile:
#     common = json.load(outfile)
# with open('message.json', 'r') as outfile:
#     message = json.load(outfile)
# with open('modules.json', 'r') as outfile:
#     modules = json.load(outfile)

# MODULES_TO_RUN = True
# COMMON_CONFIG = True
# MESSAGE = True
# DOMAIN = "pi-k3s-home"
###


if MODULES_TO_RUN and COMMON_CONFIG and MESSAGE:
    final_json = {}
    final_json.update(common)
    final_json.update(message)

    for module in modules:
        print(module)
        key = service_to_categories.get(module)
        print(key)
        if key:
            services[key]["items"].append({
                
                    "name": module.replace("-", " ").title(),
                    "logo": f"assets/icons/{module}.png",
                    "subtitle": f"{module.replace('-', ' ').title()}",
                    "tag": key,
                    "keywords": "self hosted reddit",
                    "url": f"https://{module}.{DOMAIN}.duckdns.org",
                    "target": "_blank"
                
            })
    print(services)
    final_json["services"] = list(services.values())
    with open('homer-config.json', 'w') as outfile:
        json.dump(final_json, outfile,indent=2)
else:
    print("Not passing all required env vars")
