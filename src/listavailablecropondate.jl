function listavailablecropondate(date)
    #transform date to weeks from beginning of year
    wdate = Week(Date(date)).value

    #check table of range of harvest dates
    possible_harvest_weeks = CSV.read("data/possible_harvest_weeks.csv", DataFrame)
    subdf = @where(possible_harvest_weeks, :week .== wdate)

    #check price table
    price_table = CSV.read("data/crop plan - jm_yields_and_sales.csv", DataFrame)
    cropinfo = @pipe leftjoin(subdf, price_table, on = :vegetable) |>
        @select(_, :vegetable, :week, :date, :our_yield_kg_or_unit, :desired_selling_price, 
        :unit_of_selling_price, :recommended_quantity, :roughly_equivalent_to, :price_of_recommended_quantity, :predicted_revenu_per_our_bed)

    #check standard quantity table

    #calculate price per standard quantity

    #format table
    println(sum(skipmissing(cropinfo[:, :price_of_recommended_quantity])))
    return  cropinfo# vegetable, price, unit, price/m2, standard_quantity, price_per_standard_quantity
end
