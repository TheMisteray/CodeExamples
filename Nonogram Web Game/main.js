window.onload = function () {
    //Setup grid items
    let gridString = "";
    for (let r = 0; r < 11/*Maybe a dynamic way to do this*/; r++)
    {
        for (let c = 0; c < 11; c++)
        {
            if (c == 0 && r == 0)
            {
                gridString += "<p></p>";
                continue;
            }
            if (r == 0)
            {
                gridString += "<p class='columnInfo'></p>";
                continue;
            }
            if (c == 0)
            {
                gridString += "<p class='rowInfo'></p>";
                continue;
            }
            gridString += "<p class='clickNode' oncontextmenu='return false;''></p>"
        }
    }

    document.querySelector("#grid").innerHTML = gridString;

    //Setup objects
    tiles = [
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,],
        [,,,,,,,,,]
    ]

    generateGrid();

    //Setup clicks
    let nodes = document.querySelectorAll(".clickNode");
    let row = 0;
    let column = 0;
    for (let node of nodes)
    {
        //Need to save these like this otherwise other values of row and col after the for loop are used
        let curRow = row;
        let curCol = column;
        //node.addEventListener("click", () => { activateClick(curRow, curCol) });
        //node.addEventListener("contextmenu", () => { deactivateClick(curRow, curCol) });
        //Replaced with this which does both
        node.addEventListener("mousedown", (e) => { click(curRow, curCol, e)});
        node.addEventListener("mouseenter", (e) => { dragClick(curRow, curCol, e)});

        //update row/col
        column ++;
        if (column >= 10)
        {
            column = 0;
            row ++;
        }
    }

    //Setup button controls
    document.querySelector("#start").onclick = start;
    document.querySelector("#giveup").onclick = giveUp;
    document.querySelector("#howto").onclick = howTo;
    document.querySelector("#hintbutton").onclick = hintClick;

    //Click to remove manual
    document.querySelector("#manualClose").onclick = removeHowTo;

    //Prevent right clicking since that is a game control
    document.querySelector("body").addEventListener("contextmenu", (e) => {e.preventDefault()})

    //Local storage for settings

    //Storage values
    const colorField = document.querySelector("#color");
    const dragField = document.querySelector("#dragToggle");
    const prefix = "abg9806-";

    //Storage keys
    const colorKey = prefix + "color";
    const dragKey = prefix + "drag";

    //storageretreval
    const storedColor = localStorage.getItem(colorKey);
    const storedDrag = localStorage.getItem(dragKey);

    //load stored values
    if (storedColor){
        colorField.querySelector(`option[value='${storedColor}']`).selected = true;
    }

    if (storedDrag){
        let bool = JSON.parse(storedDrag)
        dragField.checked = bool;
    }

    //Onchange triggers to save info
    
    colorField.onchange = e => {
        localStorage.setItem(colorKey, e.target.value);
        updateGrid(); //Cause changing color to activate immediately
    }

    dragField.onchange = e => {
        localStorage.setItem(dragKey, e.target.checked);
    }

    //setup audio
    clickAudio = new Audio("sounds/click.wav");
    completeAudio = new Audio("sounds/complete.wav");
    giveupAudio = new Audio("sounds/giveup.wav");
    missAudio = new Audio("sounds/miss.wav");
}

let tiles;
let completedGame = false;
let progress = 0;
let misses = 0;
let hintMode = false;
let hintCount = 1;

//audio
let clickAudio;
let completeAudio;
let giveupAudio;
let missAudio;

//Generate the game tiles and info
function generateGrid(){
    for (let i = 0; i < 10; i++) //Fill array
    {
        for (let j = 0; j < 10; j++)
        {
            if (Math.random() < .47)
            {
                tiles[i][j] = new GridTile(true);
            }
            else
            {
                tiles[i][j] = new GridTile(false);
            }
        }
    }
    
    //Reset all tiles visually
    let nodes = document.querySelectorAll(".clickNode");
    for (let node of nodes)
    {
        node.style.backgroundColor = "";
        node.innerHTML = "";
    }

    //Setup clue areas
    //rows
    let rowHints = document.querySelectorAll(".rowInfo");
    let rowCount = 0;
    for (let row of tiles)
    {
        let hints = []

        let count = 0;
        let place = 0;
        for (let tile of row)
        {
            if (tile.activeTile)
            {
                count++;
            }
            else
            {
                if (count != 0)
                {
                    hints[place] = count;
                    place++;
                    count = 0;
                }
            }
        }
        if (count != 0)
        {
            hints[place] = count;
        }


        rowHints[rowCount].innerHTML = "";
        for (let number of hints)
        {
            rowHints[rowCount].innerHTML += "<p>" + number + "</p>";
        }
        rowCount ++;
    }

    //columns
    let colHints = document.querySelectorAll(".columnInfo");
    let colCount = 0;
    for (colCount = 0; colCount < 10; colCount++)
    {
        let hints = []

        let count = 0;
        let place = 0;
        for (row of tiles)
        {
            let tile = row[colCount];
            if (tile.activeTile)
            {
                count++;
            }
            else
            {
                if (count != 0)
                {
                    hints[place] = count;
                    place++;
                    count = 0;
                }
            }
        }
        if (count != 0)
        {
            hints[place] = count;
        }

        colHints[colCount].innerHTML = "";
        for (let number of hints)
        {
            colHints[colCount].innerHTML += "<p>" + number + "</p>";
        }
    }
}

function updateGrid(giveup = false){ //visually update grid
    let nodes = document.querySelectorAll(".clickNode");
    let row = 0;
    let column = 0;
    let victory = true;

    //Get color to use
    let colorSelect = document.querySelector("#color");
    let color = colorSelect.options[colorSelect.selectedIndex].value;

    for (let node of nodes)
    {
        let obj = tiles[row][column];
        if (obj.shown == true)
        {
            if (obj.activeTile == true) {node.style.backgroundColor = color;}
            else {node.style.backgroundColor = "gray";}

            //Failed tiles have x visual
            if (tiles[row][column].success == false) {node.innerHTML = "<img src='images/Red_X.png' alt='X'>";}
        }
        else
        {
            if (obj.activeTile == true)
                victory = false; //Player has not one if an active tile hasn't been clicked
        }

        //If all active tiles are shown, game is over
        if (obj.activeTile && !obj.shown)
        {
            victory = false;
        }

        //update row/col
        column ++;
        if (column >= 10)
        {
            column = 0;
            row ++;
        }
    }

    if (victory && !completedGame)
    {
        completedGame = true; //Avoid infinite loop
        progress = 100;
        if (giveup)
        {
            giveupAudio.play();
        }
        else
        {
            completeAudio.play();
        }
        endGame();
    }

    //Update info tab
    document.querySelector("#progress").innerHTML = progress + "/100";
    document.querySelector("#misses").innerHTML = "" + misses;
    
}

//Left click
function activateClick(row, col){
    let obj = tiles[row][col];

    if (obj.shown == false)
    {
        if (hintMode)
        {
            hintMode = false;
            document.querySelector("#hintCount").innerHTML = hintCount + "/1";
            document.querySelector("#reminder").innerHTML = "Click to mark tile as active, right click to mark tile as empty.";
            document.querySelector("#game").style.backgroundColor = "rgba(0, 0, 0, 0)";
            tiles[row][col].hintClicked();
            clickAudio.cloneNode().play();
        }
        else if (!tiles[row][col].clicked(true))//Check miss
        {
            misses++;
            missAudio.play();
        }
        else//regular audio if not a miss
            clickAudio.cloneNode().play();

        progress++;
    }

    updateGrid();
}

//Right click
function deactivateClick(row, col){
    let obj = tiles[row][col];

    if (obj.shown == false)
    {
        if (hintMode)
        {
            hintMode = false;
            document.querySelector("#hintCount").innerHTML = hintCount + "/1";
            document.querySelector("#reminder").innerHTML = "Click to mark tile as active, right click to mark tile as empty.";
            document.querySelector("#game").style.backgroundColor = "rgba(0, 0, 0, 0)";
            tiles[row][col].hintClicked();
            clickAudio.cloneNode().play();
        }
        if (!tiles[row][col].clicked(false))//Check miss
        {
            misses++;
            missAudio.play();
        }
        else
            clickAudio.cloneNode().play();

        progress++;
    }

    updateGrid();
}

//End the game
function endGame(){
    for (let row of tiles)
    {
        for (let tile of row)
        {
            tile.shown = true;
            tile.success = true;
            updateGrid();
        }
    }

    //Set ending message
    let endMessage = document.querySelector("#endingMessage");
    endMessage.innerHTML = "Puzzle Complete.";
    let rating = "";
    if (misses >= 90)
        rating = "You... You intentionally got all of those wrong, right?";
    else if (misses >= 50)
        rating = "Almost like you were just randomly clicking.";
    else if (misses >= 20)
        rating = "Try again to get less misses";
    else if (misses >= 10)
        rating = "Not bad";
    else
        rating = "Great Job";
    endMessage.innerHTML += "\n" + rating;
    if (misses == 0)
    {
        endMessage.innerHTML += "\n" + "Perfect!";
    }
}

//Start game
function start(){
    if (!completedGame)
    {
        document.querySelector("#startData").innerHTML = "End current game first";
        return;
    }
    else
    {
        //Reset game
        document.querySelector("#startData").innerHTML = "-------------------------------";

        hintMode = false;
        hintCount = 1;
        document.querySelector("#hintCount").innerHTML = hintCount + "/1";
        document.querySelector("#reminder").innerHTML = "Click to mark tile as active, right click to mark tile as empty.";
        document.querySelector("#game").style.backgroundColor = "rgba(0, 0, 0, 0)";

        misses = 0;
        progress = 0;
        completedGame = false;
        tiles = [
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,],
            [,,,,,,,,,]
        ]
        generateGrid();
        updateGrid();

        //Remove extra message
        let endMessage = document.querySelector("#endingMessage");
        endMessage.innerHTML = "";
    }
}

//forcefully ends game, marking all hidden tiles as misses
function giveUp(){
    let progNow = progress;
    for (let row of tiles)
    {
        for (let tile of row)
        {
            if (tile.shown == false)
            {
                tile.shown = true;
                tile.success = false;
                misses++;
            }
        }
    }
    updateGrid(true);
    giveupAudio.play();
    document.querySelector("#progress").innerHTML = progNow + "/100"; //Keep old progress if player gave up

    let endMessage = document.querySelector("#endingMessage");
    endMessage.innerHTML = "Gave Up. <br>Try again! You can do it!";
}

//Bring up manual
function howTo(){
    let graphic = document.querySelector("#manual");
    graphic.style.left = 0;
}

//Get rid of manual
function removeHowTo(){
    let graphic = document.querySelector("#manual");
    graphic.style.left = '-200vw';
}

//Activates effects of hint button
function hintClick(){
    if (hintCount == 0)
    {
        if (hintMode)
        {
            hintCount++;
            hintMode = false
            document.querySelector("#hintCount").innerHTML = hintCount + "/1";
            document.querySelector("#reminder").innerHTML = "Click to mark tile as active, right click to mark tile as empty.";
            document.querySelector("#game").style.backgroundColor = "rgba(0, 0, 0, 0)";
        }
        return;
    }
    hintCount--;
    hintMode = true;
    document.querySelector("#hintCount").innerHTML = "Hint mode active!";
    document.querySelector("#reminder").innerHTML = "Click any tile to learn what it is!";
    document.querySelector("#game").style.backgroundColor = "rgba(0, 0, 0, .5)";
}

//handles clicking
function click(curRow, curCol, e){
    let button = e.buttons;
    e.preventDefault(); //prevents context menu
    if (button == 1)
    {
        activateClick(curRow, curCol);
    }
    else if (button == 2){
        deactivateClick(curRow, curCol);
    }
}

//Handles draggin
function dragClick(curRow, curCol, e){
    let button = e.buttons;
    e.preventDefault(); //Prevents highlighting or interacting with X images
    if (!document.querySelector("#dragToggle").checked) //if dragging is disabled return
    {
        return;
    }
    if (button == 1)
    {
        activateClick(curRow, curCol);
    }
    else if (button == 2){
        deactivateClick(curRow, curCol);
    }
}