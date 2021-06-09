#import statements
from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup
from flask import Flask
import flask
import re
app = Flask(__name__)

def prepare_data(data):     #this converts the data into useable format
    term = data.strip().replace(" ", "+")
    return term

# data = input("Enter food: ")
# data = prepare_data(data)
# my_url = 'https://www.myfitnesspal.com/food/search?page=1&search='+data

def scraper(my_url):
    uClient = uReq(my_url)    #this loads the site in the bg
    page_html = uClient.read()      #this reads the file as html
    uClient.close()
    page_soup = soup(page_html, "html.parser")      #the html file is stored in accessible format
    dct ={}
    lst = []
    for divs in page_soup.find_all("div",{"class":"jss60"}):       #gets all the divs with classname jss60
        div1 = divs.find("div",{"class":"jss64"})       #gets all the divs with classname jss64 inside jss60
        c = div1.a.text

        res = re.sub(" +", ' ', c)      #what these two lines do is
        dct["item_name"]=str(c)         #convert " chicken       soup   " => "chicken soup"

        div1 = divs.find("div",{"class":"jss65"})       #gets all the divs with classname jss65 inside jss60
        a = div1.text
        a = a.split(', ')
        food_name = a[0]
        dct["item_desc"]=food_name
        food_quantity = a[1]
        food_quantity = food_quantity.split(" ")
        quantity = food_quantity[0]
        dct["nf_serving_size_quantity"] = quantity
        unit = food_quantity[-1]
        dct["nf_serving_size_unit"]=unit
        div2 = divs.find("div",{"class":"jss70"})       #gets all the divs with classname jss70 inside jss60
        b = div2.text
        b = b.split()
        calories = b[1]
        dct["calories"]=calories
        carbs = b[3]
        dct["nf_total_carbohydrate"]=carbs[:-1]
        fats = b[5]
        dct["nf_total_fat"]=fats[:-1]
        protein = b[7]
        dct["nf_protein"]=protein[:-1]
        lst.append(dct.copy())
    
    final_api = {
        "total_hits":10,
        "max_score": 10,
        "hits": lst
    }
    return final_api
# print(scraper(my_url))

@app.route("/<query>", methods=["GET", "POST"])         #this funct accepts a query(food_name) 
def api(query):                                         #from the front end
    if query != None:                                   #and returns data to the frontend
        data = prepare_data(query)                      #all exchange of data, to and from frontend is in JSON format
        my_url = 'https://www.myfitnesspal.com/food/search?page=1&search='+data
        return scraper(my_url)
    else:
        return {
            "total_hits": 0
        }