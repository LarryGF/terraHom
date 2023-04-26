import os
import json

# Get environment variables
MODULES_TO_RUN = os.getenv("MODULES_TO_RUN",False)
COMMON_CONFIG = os.getenv("COMMON_CONFIG",False)
MESSAGE = os.getenv("MESSAGE", False)
DOMAIN = os.getenv("DOMAIN", False)

# Parse environment variables into Python data types
modules = json.loads(MODULES_TO_RUN)
common = json.loads(COMMON_CONFIG)
message = json.loads(MESSAGE)

# Map service names to categories and icons
service_to_categories = {
    "bazarr": "media",
    "flood": "public-services",
    "duckdns": "internal-services",
    "adguardhome": "internal-services",
    "duplicati": "internal-services",
    "longhorn": "internal-services",
    "heimdall": "public-services",
    "qbittorrent": "public-services",
    "home-assistant": "public-services",
    "filebrowser": "public-services",
    "filebrowser": "public-services",
    "mylar": "public-services",
    "readarr": "public-services",
    "prowlarr": "public-services",
    "jellyseerr": "media",
    "whisparr": "media",
    "radarr": "media",
    "sonarr": "media",
    "jellyfin": "media",
    "test": "empty",
    "grafana": "monitoring",
}

icon_map = {
    "media": "fas fa-film",
    "public-services": "fas fa-hard-drive",
    "internal-services": "fas fa-server",
    "monitoring": "fas fa-chart-line",
    "empty": "fas fa-xmark",
}

# Initialize dictionary to hold categorized services
categories = set(service_to_categories.values())
services = {category:{
    "name": category.replace("-", " ").title(),
    "icon": icon_map[category],
    "items": []
} for category in categories}

# Populate categorized services with data from environment variables
if MODULES_TO_RUN and COMMON_CONFIG and MESSAGE:
    print("All required environment variables are present")

    final_json = {}
    final_json.update(common)
    final_json.update(message)

    for module in modules:
        print(f"Processing module {module}")

        key = service_to_categories.get(module)
        if key:
            services[key]["items"].append({
                
                    "name": module.replace("-", " ").title(),
                    "logo": f"assets/icons/{module}.png",
                    "subtitle": f"{module.replace('-', ' ').title()}",
                    "tag": key,
                    "tagstyle": "is-warning",
                    "keywords": "self hosted reddit",
                    "url": f"https://{module}.{DOMAIN}.duckdns.org",
                    "target": "_blank"
                
            })

    print("Categorized services:", services)

    
    # Remove categories with no items and sort the remaining categories
    keys = list(services.keys())
    for key in keys:
        if len(services[key]["items"]) == 0:
            print(f"Deleting category {key} because it has no items")

            del services[key]

    order = list(icon_map.keys())
    services = list(services.values())
    sorted_services = sorted(services,key= lambda x: order.index(x["name"].replace(" ", "-").lower()))
    
    # Update the final JSON object with sorted services and write to file
    final_json["services"] = sorted_services
    with open('homer-config.json', 'w') as outfile:
        json.dump(final_json, outfile,indent=2)
else:
    print("Not passing all required env vars")
