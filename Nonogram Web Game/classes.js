class GridTile{
    constructor(activeTile)
    {
        this.activeTile = activeTile;
        this.shown = false; //Tracks if a tile should show itself (and if it has been clicked)
        this.success = false; //tracks if the correct input was used
    }

    clicked(left)
    {
        this.shown = true;
        if (this.activeTile == true)
        {
            if (left == true)
            {
                this.success = true;
            }
            else
            {
                this.success = false;
            }
        }
        else
        {
            if (left == true)
            {
                this.success = false;
            }
            else
            {
                this.success = true;
            }
        }

        return this.success;
    }

    hintClicked()
    {
        this.shown = true;
        this.success = true;
    }
}