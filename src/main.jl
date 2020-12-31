# This is a Crop planner the goal is to input a list of crop and output a list of tasks (planting, seeding, harvesting) and expectation (yield, money, ).
# The crop planner will presume that one unit of crop = 1 meter square

module CropPlanner

using HTTP
using JSON
using DataFrames
using DataFramesMeta
using Pipe
using CSV
using Dates
using JSON3
using Unitful, Unitful.DefaultSymbols
using UnitfulUS

crop_notes = CSV.read("crop plan - jm_crop_notes.csv", DataFrame)

1u"inch"+(1/8)u"inch" |> u"ft" |> u"inch"

DateTime("May 10", DateFormat("May 10"))
Dates.LOCALES["english"].month_value["may"]


end


