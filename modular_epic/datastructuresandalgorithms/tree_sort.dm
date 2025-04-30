/datum/tree_sort/New(var/value = null, var/key = null)
    if (value && key)
        Insert(value, key)

/datum/tree_sort/proc/Insert(var/value, var/key)
    if (!NodeValue)
        NodeValue = value
        NodeKey = key
    else if (value > NodeValue)
        if (!rightNode)
            rightNode = new /datum/tree_sort(value, key)
        else
            rightNode.Insert(value, key)
    else
        if (!leftNode)
            leftNode = new /datum/tree_sort(value, key)
        else
            leftNode.Insert(value, key)

/datum/tree_sort/proc/GetOrderedList()
    var/list/datum/sorted_list = list()
    if (leftNode)
        sorted_list += leftNode.GetOrderedList()
    sorted_list += src
    if (rightNode)
        sorted_list += rightNode.GetOrderedList()
    return sorted_list

/datum/tree_sort
    var/NodeValue
    var/NodeKey

    var/datum/tree_sort/leftNode = null
    var/datum/tree_sort/rightNode = null
