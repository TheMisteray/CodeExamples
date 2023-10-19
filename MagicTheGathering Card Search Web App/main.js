window.onload = function (e) //Setup storage and onclick functionality
{
    document.querySelector("#search").onclick = searchButtonClicked;

    //Storage values
    const searchField = document.querySelector("#searchterm");
    const colorSelect = document.querySelectorAll("input[name='color']");
    const rareSelect = document.querySelectorAll("input[name='rarity']");
    const typeSelect = document.querySelectorAll("input[name='cardType']");
    const customTypeField = document.querySelector("#extraCardType");
    const costSelect = document.querySelector("#cmc");

    const prefix = "abg9806-";

    //Storage keys
    const searchKey = prefix + "searchTerm";
    const colorKey = prefix + "color";
    const rareKey = prefix + "rare";
    const typeKey = prefix + "type";
    const customTypeKey = prefix + "customType";
    const costKey = prefix + "cost";

    //Storage retreval
    const storedSearch = localStorage.getItem(searchKey);
    const storedColor = localStorage.getItem(colorKey);
    const storedRarity = localStorage.getItem(rareKey);
    const storedType = localStorage.getItem(typeKey);
    const storedCustomType = localStorage.getItem(customTypeKey);
    const storedCost = localStorage.getItem(costKey);

    //Load stored values
    if (storedSearch){
        searchField.value = storedSearch;
    }
    else{
    searchField.value = "";
    }

    if (storedColor){
        let num = 0;
        let colorsArray = JSON.parse(storedColor);
        for (let bool of colorsArray){
            if (bool)
            {
                colorSelect[num].checked = true;
            }
            num++;
        }
    }

    if (storedRarity){
        rareSelect[storedRarity].checked = true;
    }

    if (storedType){
        let num = 0;
        let typesArray = JSON.parse(storedType);
        for (let bool of typesArray){
            if (bool)
            {
                typeSelect[num].checked = true;
            }
            num++;
        }
    }

    if (storedCustomType){
        customTypeField.value = storedCustomType;
    }
    else{
        customTypeField.value = "";
    }

    if (storedCost){
        costSelect.querySelector(`option[value='${storedCost}']`).selected = true;
    }

    //Setup onchange event triggers to save settings
    searchField.onchange = e=>{localStorage.setItem(searchKey, e.target.value);};

    for (let color of colorSelect) //Each color button updates stored array for colors
    {
        color.onchange = function (){
            let num = 0;
            let colors = [false, false, false, false, false, false];
            for (let options of colorSelect)
            {
                if (options.checked)
                    colors[num] = true;
                num++;
            }

            //Extra setting for the colorless button so it doen't cause bad searches as often
            if (color.value == "c")
            {
                for (let i = 0; i <colorSelect.length - 1; i++)
                {
                    colorSelect[i].checked = false;
                    colors[i] = false;
                }
            }
            else
            {
                colorSelect[colorSelect.length-1].checked = false;
                colors[colors.length - 1] = false;
            }

            //Send stringified array
            localStorage.setItem(colorKey, JSON.stringify(colors));
        }
    }

    for (let rare of rareSelect)
    {
        rare.onchange = function (){
            let num = 0;
            for (let options of rareSelect)
            {
                if (options.checked)
                    localStorage.setItem(rareKey, num);
                num++;
            }
        }
    }

    for (let type of typeSelect) //Each type button updates stored array for types
    {
        type.onchange = function (){
            let num = 0;
            let types = [false, false, false, false, false, false, false, false];
            for (let options of typeSelect)
            {
                if (options.checked)
                    types[num] = true;
                num++;
            }
            //Send stringified array
            localStorage.setItem(typeKey, JSON.stringify(types));
        }
    }

    //Save custom type in local storage
    customTypeField.onchange = e=>{localStorage.setItem(customTypeKey, e.target.value)};

    //Save chosen cmc in local storage
    costSelect.onchange = e=>{ localStorage.setItem(costKey, e.target.value);};


    //Give the card display div an action to display itself
    let cardDisplay = document.querySelector("#bigCard");
    cardDisplay.addEventListener("click", removeLargeDisplay);
}

let displayTerm = "";

function searchButtonClicked(){ //Perform search
    //Get api url
    const API_URL = "https://api.scryfall.com/cards/search?";

    //start to build string
    let url = API_URL;

    //Parse intended user term
    let term = document.querySelector("#searchterm").value;
    displayTerm = term;

    //get rid of excess spaces
    term = term.trim();

    //encode spaces and special characters
    term = encodeURIComponent(term);

    //append search term if there is one
    if (term.length > 0)
        url += "q=" + term;
    else
        url += "q=";
    //append other components
    //Color
    let colorOptions = document.querySelectorAll("input[name='color']");
    let colors = "+c:";
    for (let c of colorOptions)
    {
        if (c.checked)
        {
            colors += c.value;
        }
    }
    if (colors != "+c:")
        url += colors;

    //Rarity
    let rare = document.querySelectorAll("input[name='rarity']");
    let rarity = "";
    for (let r of rare)
    {
        if (r.checked)
        {
            if (r.value != "")
                rarity = "+r:" + r.value;
            url += rarity;
        }
    }

    //Types
    let cardTypes = document.querySelectorAll("input[name='cardType']");
    let types = "";
    for (let t of cardTypes)
    {
        if (t.checked)
            types += "+t:" + t.value;
    }
    let extraCardType = document.querySelector("#extraCardType").value;
    //get rid of excess spaces
    extraCardType = extraCardType.trim();
    //encode spaces and special characters
    extraCardType = encodeURIComponent(extraCardType);
    if (extraCardType.length > 1)
        types += "+t:" + extraCardType;
    url += types;

    //cmc
    let cost = document.querySelector("select");
    let amount = cost.options[cost.selectedIndex].value;
    let cmc="";
    if (amount.length < 1)
        cmc = "";
    else
        cmc += "+cmc:" + amount;
    url += cmc;

    //update UI
    document.querySelector("#status").innerHTML = "<b>Searching for Cards</b><br><br><img src='images/search.jpg'>";

    //Request data
    getData(url);
}

//GetData function
function getData(url){
    if(url == "https://api.scryfall.com/cards/search?q=")
    {
        document.querySelector("#status").innerHTML = "<b>No search settings entered, please enter some settings</b><br><br><img src='images/path.JPG'>";
        document.querySelector("#content").innerHTML = "";
        return;
    }

    //create new xhr object
    let xhr = new XMLHttpRequest();

    //set the onload handler
    xhr.onload = dataLoaded;

    //set onerror handler
    xhr.onerror = dataError;

    //open connection and send the request
    xhr.open("GET", url);
    xhr.send();
}

function dataLoaded(e){
    //event.target is the xhr object
    let xhr = e.target;

    //turn the text into a parseable JavaScript object
    let obj = JSON.parse(xhr.responseText);

    //if no results print message and return
    if (!obj.data|| obj.data.length == 0)
    {
        document.querySelector("#status").innerHTML = "<b>No results found</b><br><br><img src='images/nothing.JPG'>";
        //Empty out results so the user can more obviously tell the search failed
        document.querySelector("#content").innerHTML = "";
        return;
    }

    //start building an HTML string we will display to the user
    let results = obj.data;
    let bigString = "";

    //loop through the array of results
    for (let i = 0; i<results.length; i++)
    {
        let result = results[i];

        //Get image
        let smallURL = "";
        if (result.card_faces)
        {
            if (result.card_faces[0].image_uris)
            {
                smallURL = result.card_faces[0].image_uris["png"];   
            }
            else
            {
                //So apparently adevnture cards, to cards, and or cards count as multi-faced cards by scryfall even though they only have one actual card face
                //This means that if the faces have no image to retreive then I have to go back to the main card object which should have it
                smallURL = result.image_uris["png"];
            }
        }
        else if (result.image_uris)
        {
            smallURL = result.image_uris["png"];   
        }
        if (!smallURL) smallURL = "images/no-image-found.png";

        let Name = "Name Not Found";
        if (result.name) {
            Name = result.name;
        }

        //Scryfall page link
        let url = result.scryfall_uri;

        //Build a <div> to hold each result
        //ES6 String Templating
        let line = `<div class='result'><img src='${smallURL}'>`;
        line += `<span><a target='_blank' href='${url}'>View on Scryfall</a></span><span>${Name}</span></div>`;

        //15? add div to bigsting and loop
        bigString += line;
    }

    //all done building HTML so show it to the user
    document.querySelector("#content").innerHTML = bigString;

    //Setup click events now that content is constucted
    //Give all card images an onclick
    let cardImages = document.querySelectorAll("#content .result img");
    for (let card of cardImages)
    {
        card.addEventListener("click", pullUpLargeDisplay);
        card.addEventListener("mouseover", cardGlow);
        card.addEventListener("mouseout", cardGlowRemove);
    }

    //update status
    document.querySelector("#status").innerHTML = "<p><i><b>We found " + results.length + " results matching your search</b></i></p>";

    //Scryfall caps you at 175, so change status message to not mislead user into thinking there are only 175 results
    if (results.length >=175)
        document.querySelector("#status").innerHTML = "<p><i><b>Here are the first " + results.length + " results matching your search</b></i></p>";
}

function dataError(e){ // Error handling
    document.querySelector("#status").innerHTML = "<p><i><b>An unexpected error occured, please try again.</b></i></p>";
}

//Put card image in large display
let pullUpLargeDisplay = (e) =>{
    let graphic = document.querySelector("#bigCard");
    graphic.innerHTML = `<img src='${e.target.src}'>`;
    graphic.style.width = "100%";
    graphic.style.height = "100vh";
}

//Remove large card display
let removeLargeDisplay = (e) =>{
    let graphic = document.querySelector("#bigCard");
    graphic.innerHTML = "";
    graphic.style.width = "0px";
    graphic.style.height = "0px";
}

//Give border to card to make it seem clickable
let cardGlow = (e) =>{
    e.target.style.border = "1px solid white";
}

//Remove card glow when mouse is gone
let cardGlowRemove = (e) =>{
    e.target.style.border = "";
}