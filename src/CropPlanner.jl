 CropPlanner

import HTTP
import JSON
import DataFrames
using DataFramesMeta
using Pipe
import CSV
using Dates
using Unitful, Unitful.DefaultSymbols
using UnitfulUS


include("convertstringarray.jl")
include("tosiunits.jl")
include("addseedingdateoftransplant!.jl")

vegdic = JSON.parse(String(read("data/vegetable_name_dictionary.json")))

# Create table of range of harvest_dates
crop_calendar = CSV.read("data/crop plan - ecoumene_crop_calendar.csv", DataFrames.DataFrame)
crop_calendar[!,:vegetable] = [get(vegdic, v, v) for v in  crop_calendar[!,:vegetable]]

rename!(crop_calendar, [ i => crop_calendar[1,i] for i in 3:ncol(crop_calendar)])
crop_calendar1 = crop_calendar[3:end,:]

possible_harvest_weeks = @pipe crop_calendar1 |>
    @where(_, :activity .== "harvest") |>
    stack(_, 3:ncol(_)) |>
    dropmissing |>
    @transform(_, week = [i.value for i in Week.(Date.(:variable, DateFormat("m/d/y")))]) |>
    @select(_, :vegetable, :activity, :week, date = :variable)

CSV.write("data/possible_harvest_weeks.csv", possible_harvest_weeks)

# Load tables 
crop_notes = CSV.read("data/crop plan - jm_crop_notes.csv", DataFrames.DataFrame)
crop_notes[!,:vegetable] = [get(vegdic, v, v) for v in  crop_notes[!,:vegetable] ]
CSV.write("data/crop plan - jm_crop_notes.csv",crop_notes)

garden_plan = CSV.read("data/crop plan - jm_garden_plan.csv", DataFrames.DataFrame)
garden_plan[!,:vegetable] = [get(vegdic, v, v) for v in  garden_plan[!,:vegetable] ]
CSV.write("data/crop plan - jm_garden_plan.csv",garden_plan)

transplant_table = CSV.read("data/crop plan - jm_transplant_table.csv", DataFrames.DataFrame)
transplant_table[!,:vegetable] = [get(vegdic, v, v) for v in  transplant_table[!,:vegetable] ]
CSV.write("data/crop plan - jm_transplant_table.csv",transplant_table)

yields_and_sales = CSV.read("data/crop plan - jm_yields_and_sales.csv", DataFrames.DataFrame)
yields_and_sales[!,:vegetable] = [get(vegdic, v, v) for v in  yields_and_sales[!,:vegetable] ]
CSV.write("data/crop plan - jm_yields_and_sales.csv",yields_and_sales)

possible_harvest_weeks = CSV.read("data/possible_harvest_weeks.csv", DataFrame)

all_vegdf = DataFrame(vegetable = unique(outerjoin(crop_notes, garden_plan, transplant_table, yields_and_sales, possible_harvest_weeks, on = :vegetable,makeunique = true)[:,:vegetable]))

crop_df = outerjoin(crop_notes, garden_plan, transplant_table, yields_and_sales, on = :vegetable,makeunique = true)

crop_df_cln = @transform(crop_df, 
    intensive_spacing_between_rows_in = tosiunits.(:intensive_spacing_between_rows_in),
    intensive_spacing_within_rows_in = tosiunits.(:intensive_spacing_within_rows_in),
    preferred_cultivars = convertstringarray.(:preferred_cultivars),
    dates_of_seedings = convertstringarray.(:dates_of_seeding_of_transplant),
    dates_of_transplanting = convertstringarray.(:dates_of_transplanting),
    period_of_harvest_days = convertodays.(:period_of_harvest_days),
    days_in_garden_min = convertodays.(:days_in_garden_min),
    days_in_garden_max = convertodays.(:days_in_garden_max),
    date_in = converttodate.(:date_in),
    date_out = converttodate.(:date_out)
    )

crop_df_cln[ismissing.(crop_df_cln[!,:period_of_harvest_days]), :period_of_harvest_days] .= Day(0)

addseedingdateoftransplant!(crop_df_cln)
addearliestharvest!(crop_df_cln)

show(names(crop_df_cln))
sort!(crop_df_cln, :earliest_harvest)

# Create possible_harvest_weeks for JM info
jm_harvest_range = @pipe crop_df_cln |>
    groupby(_, :vegetable) |>
    @combine(_,  
        min_harvest = minimum(:earliest_harvest),
        max_harvest = maximum(:date_out)
    )

CSV.write("tmp.csv", jm_harvest_range)





end
