module CropPlanner

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

crop_notes = CSV.read("data/crop plan - jm_crop_notes.csv", DataFrames.DataFrame)
crop_notes[!,:vegetable] = [get(vegdic, v, v) for v in  crop_notes[!,:vegetable] ]

garden_plan = CSV.read("data/crop plan - jm_garden_plan.csv", DataFrames.DataFrame)
garden_plan[!,:vegetable] = [get(vegdic, v, v) for v in  garden_plan[!,:vegetable] ]

transplant_table = CSV.read("data/crop plan - jm_transplant_table.csv", DataFrames.DataFrame)
transplant_table[!,:vegetable] = [get(vegdic, v, v) for v in  transplant_table[!,:vegetable] ]

yields_and_sales = CSV.read("data/crop plan - jm_yields_and_sales.csv", DataFrames.DataFrame)
yields_and_sales[!,:vegetable] = [get(vegdic, v, v) for v in  yields_and_sales[!,:vegetable] ]

crop_calendar = CSV.read("data/crop plan - ecoumene_crop_calendar.csv", DataFrames.DataFrame)
crop_calendar[!,:vegetable] = [get(vegdic, v, v) for v in  crop_calendar[!,:vegetable]]

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

addseedingdateoftransplant!(crop_df_cln)
addearliestharvest!(crop_df_cln)

show(names(crop_df_cln))
sort!(crop_df_cln, :earliest_harvest)

aragula = @where(crop_df, :vegetable .== "arugula")
broccoli = @where(crop_df, :vegetable .== "broccoli")
tomato = @where(crop_df, :vegetable .== "tomato")
carrot = @where(crop_df, :vegetable .== "carrot")


CSV.write("tmp.csv", crop_df_cln)

Dates.Day(Dates.DateTime("August 1", Dates.DateFormat("U d")) - Dates.DateTime("April 20", Dates.DateFormat("U d")))
Dates.Day(Dates.DateTime("2021 July 1", Dates.DateFormat("y U d")) - Dates.DateTime("2020 October 1", Dates.DateFormat("y U d")))

Dates.LOCALES["english"].month_value["may"]


end

