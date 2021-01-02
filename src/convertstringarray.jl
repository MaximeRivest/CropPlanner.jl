"""
 Tst
"""
function convertstringarray(s)
    if !ismissing(s)
        m = match(r"(?<=\[).*(?=\])", s)
        if isnothing(m)
            println(s)
        end
        m = replace(m.match, r"\s" => "")
        m = split(m, ",")
        return convert.(String, m)
    else
        return []
    end
end