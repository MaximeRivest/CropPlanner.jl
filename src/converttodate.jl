function converttodate(s)
    if !ismissing(s)
        return Date("$(year(today())) $(s)", DateFormat("y U d"))    
    else
        return missing
    end
end
    