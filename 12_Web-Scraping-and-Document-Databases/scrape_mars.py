from bs4 import BeautifulSoup
from splinter import Browser
import time
import pandas as pd

def init_browser():
    executable_path = {'executable_path': 'Resources/chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

def scrape_info():
    browser = init_browser()


    #-----Visit Mars News-----#
    # Scrape News Title and News Paragraph Text
    url = 'https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest'
    browser.visit(url)
    time.sleep(1)

    # Scrape page into Soup
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')

    # Narrow search 
    results = soup.find_all('li', class_='slide')

    # News Title
    news_title = results[0].find("div", class_='content_title').text

    # News Paragraph Text
    news_p = results[0].find("div", class_='article_teaser_body').text


    #-----Visit Mars Space Images-----#
    # Scrape Image URL
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)
    time.sleep(1)

    # Click to see full image
    browser.click_link_by_id('full_image')

    # Scrape page into Soup
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')

    # Narrow search 
    results = soup.find_all('footer')

    # Featured image url
    image_url = results[0].a['data-fancybox-href']
    featured_image_url = 'https://www.jpl.nasa.gov' + image_url


    #-----Visit Mars Twittter-----#
    # Scrape Mars Weather
    url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(url)
    time.sleep(1)

     # Scrape page into Soup
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')

    # Narrow search 
    results = soup.find_all('div', class_='content')

    # Mars weather
    mars_weather = results[0].p.text[:-29]


    #-----Visit Mars Facts-----#
    # Scrape Mars Facts Table
    url = 'https://space-facts.com/mars/'
    tables = pd.read_html(url)

    df = tables[1]
    df.columns = ['','value']
    df.set_index('', inplace=True)

    # Mars facts tables
    mars_facts = df.to_html()


    #-----Visit Mars Facts-----#
    # Scrape Mars Facts Table
    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    hemisphere_links = ['Cerberus Hemisphere Enhanced', 
                        'Schiaparelli Hemisphere Enhanced', 
                        'Syrtis Major Hemisphere Enhanced',
                        'Valles Marineris Hemisphere Enhanced']

    hemisphere_image_urls = []

    # Loop through each hemisphere page to collect images and titles
    for link in hemisphere_links:
        info = {}
    
        # Visit URL
        browser.visit(url)
        time.sleep(1)
    
        # Click the link to each hemisphere in the list
        browser.click_link_by_partial_text(link)
        html = browser.html
        soup = BeautifulSoup(html, 'html.parser')
       
        # Scrape title
        results = soup('div', class_='content')
        info["title"] = results[0].h2.text
    
        # Scrape full image link
        results = soup('div', class_='downloads')
        info["img_url"] = results[0].a['href']
    
        hemisphere_image_urls.append(info)

    # Store data in a dictionary
    scrape_data = {
        "news_title": news_title,
        "news_p": news_p,
        "featured_image_url": featured_image_url,
        "mars_weather": mars_weather,
        "mars_facts": mars_facts,
        "hemisphere_image_urls": hemisphere_image_urls
    }
    # Quit the browser after scraping
    browser.quit()

    # Return results
    return scrape_data