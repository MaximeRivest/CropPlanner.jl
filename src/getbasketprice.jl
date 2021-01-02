function getbasketprice()
    basket = JSON.parse(string("""{
        "date":"2021-06-20",
        "vegetables": [
            {
                "vegetable": "broccoli",
                "quantity": "2",
                "unit": "unit"
            },{
                "vegetable": "tomato",
                "quantity": "1",
                "unit": "kg"
            }
        ]
    }"""))

    #transform basket to a table

    #left join with a table of price

    #convert quantities

    #multiply price and quantity

    return #sum of prices
end