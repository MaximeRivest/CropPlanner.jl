"""
 Tst
"""
function tosiunits(s)
    if !ismissing(s)
        a = split(s, " ")
        r = sum(Quantity.(eval.(Meta.parse.(a)), u"inch")) |> u"cm"
        round(typeof(1u"cm"), r)
    else
        missing
    end
end
