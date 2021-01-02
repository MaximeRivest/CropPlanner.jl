function addearliestharvest!(df)
    df[!,:days_in_garden_until_first_harvest] =  Array{Union{Missing, Day},1}(missing, nrow(df))
    df[!,:earliest_harvest] = Array{Union{Missing, Date},1}(missing, nrow(df))

    for row in eachrow(df)
        if !ismissing(row[:days_in_garden_min]) & !ismissing(row[:period_of_harvest_days])
            row[:days_in_garden_until_first_harvest] = row[:days_in_garden_min] - row[:period_of_harvest_days]
            if !ismissing(row[:date_in])
                row[:earliest_harvest] = Date(row[:date_in] + row[:days_in_garden_until_first_harvest])
            end
        end
    end
end