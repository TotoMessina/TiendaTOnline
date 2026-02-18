import os
import requests
import time
import sys
from duckduckgo_search import DDGS

# Forzar UTF-8 en consola de Windows
sys.stdout.reconfigure(encoding='utf-8')

# CONFIGURACIÓN
# Tomada de script.js
SUPABASE_URL = 'https://eeltuofcdqekccypwykm.supabase.co'
SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbHR1b2ZjZHFla2NjeXB3eWttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE0MDU2MDAsImV4cCI6MjA4Njk4MTYwMH0.n9viYMxD4JbtPZNLs6TdfRuWQfmPhgX5MsZ4y3hG7RY'

HEADERS = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal"
}

def get_products_without_images():
    url = f"{SUPABASE_URL}/rest/v1/productos?select=id,nombre&or=(imagen_url.is.null,imagen_url.eq.)"
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        print(f"Error fetching products: {response.text}")
        return []
    return response.json()

def search_image(query):
    try:
        with DDGS() as ddgs:
            # Buscar 1 imagen
            results = list(ddgs.images(query, max_results=1))
            if results:
                return results[0]['image']
    except Exception as e:
        print(f"  Error searching image for '{query}': {e}")
    return None

def update_product_image(product_id, image_url):
    url = f"{SUPABASE_URL}/rest/v1/productos?id=eq.{product_id}"
    data = {"imagen_url": image_url}
    response = requests.patch(url, headers=HEADERS, json=data)
    if response.status_code in [200, 204]:
        return True
    else:
        print(f"  Error updating product {product_id}: {response.status_code} - {response.text}")
        return False

def main():
    print("--- AUTOMATED IMAGE ENRICHMENT ---")
    
    products = get_products_without_images()
    print(f"Found {len(products)} products without images.")
    
    if not products:
        print("No products to update.")
        return

    count = 0
    for p in products:
        search_term = f"{p['nombre']} producto argentina" # Refine search
        print(f"[{count+1}/{len(products)}] Searching for: '{p['nombre']}'...")
        
        image_url = search_image(search_term)
        
        if image_url:
            print(f"  Found: {image_url[:50]}...")
            if update_product_image(p['id'], image_url):
                print("  Saved!")
                count += 1
            else:
                print("  Failed to save.")
        else:
            print("  No image found.")
            
        time.sleep(1) # Be nice to DDG

    print(f"\nDone! Updated {count} products.")

if __name__ == "__main__":
    main()
