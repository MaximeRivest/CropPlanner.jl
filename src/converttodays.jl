function convertodays(x)
    if ismissing(x)
        return missing
    else
        return Day(x)
    end
end