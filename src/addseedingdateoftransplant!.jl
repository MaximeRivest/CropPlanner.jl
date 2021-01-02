function addseedingdateoftransplant!(df)
    df[!,:seeding_date_of_transplant] = Array{Union{Missing, Date},1}(missing, nrow(df))
    for row in eachrow(df)
        if !ismissing(row[:planting])
            if (row[:planting] == "T") & !ismissing(row[:number_of_days_in_cell] & !ismissing(row[:date_in]))
                row[:seeding_date_of_transplant] = row[:date_in] - Day(row[:number_of_days_in_cell])
            end
        end
    end
end