function getbasketprice(basket)
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
    basket_df = reduce(vcat, DataFrame.(basket["vegetables"]))

    #left join with a table of price
    price_table = CSV.read("data/crop plan - jm_yields_and_sales.csv", DataFrame)
    res = @pipe leftjoin(basket_df, price_table, on = :vegetable, makeunique = true) |>
        @transform(_, item_price = parse.(Int64, :quantity) .* :desired_selling_price)
        
    return sum(res[!, :item_price])
end