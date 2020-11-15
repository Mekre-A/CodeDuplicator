import java.lang.NumberFormatException

fun getUserInput() {

    println("Do you want to build all branches? (Master and Test will be excluded by default)")

    var userInput: String? = readLine()

    if (userInput.equals("y")) {
        println("Starting to build All branches")
        return
    } else if (userInput.equals("n")) {
        println("Please enter the number of your branches you want to exclude, If there are more than one branches to exclude enter them buy separating with a comma" +
                "For Eg. 1,2,3")
        userInput = readLine()

        println(performUserInputValidation(userInput))

    }


}

fun performUserInputValidation(userInputParameter: String?): String {
    var userInput: String? = userInputParameter
    var shouldUserInputAgain: Boolean = false;

    main@ while (true) {
        if (shouldUserInputAgain) {
            userInput = readLine()
            shouldUserInputAgain = false
        }

        if (userInput.isNullOrEmpty()) {
            println("You have entered nothing, Please try again")
            shouldUserInputAgain = true
            continue@main
        }

        if (userInput.toUpperCase().trim() == "EXIT") {
            return "exit"
        }

        userInput = checkForTrailingComma(userInput)

        userInput = removeWhiteSpaceBetweenCommaAndNumber(userInput)


        val onlyIntEvaluated: String = checkForOnlyIntInputs(userInput)

        if (onlyIntEvaluated != "") {
            println("Please enter only Integers, You have entered $onlyIntEvaluated, Please try again")
            shouldUserInputAgain = true;
            continue@main
        }

        if (containDuplicates(userInput)) {
            println("Your input contains duplicates, Do you want continue(Y/N)? " +
                    "If you continue, we won't build twice but use the duplicated value only once")
            while (true) {
                val status: Int = confirmFromUser()
                if (status == 0) {
                    return "exit"
                } else if (status == 1) {
                    userInput = removeDuplicates(userInput.toString())
                    break
                } else if (status == 2) {
                    println("Please try again")
                    shouldUserInputAgain = true
                    continue@main
                } else {
                    println("Please enter a proper input (Y/N)")
                }
            }
        }

        val rangeEvaluatedInput: String = checkForItemsInRange(userInput.toString())
        if (rangeEvaluatedInput != "") {
            println("Out of range values: $rangeEvaluatedInput")
            println("The value/s that you have entered is/are out of range, Please try again")
            shouldUserInputAgain = true
            continue@main
        }
        break
    }
    return userInput.toString()


}

fun checkForTrailingComma(userInput: String): String {
    return userInput.removeSuffix(",")
}

fun confirmFromUser(): Int {
    val userInput: String? = readLine()
    return if (userInput?.toUpperCase() == "Y" || userInput?.toUpperCase() == "YES") {
        0
    } else if (userInput?.toUpperCase() == "N" || userInput?.toUpperCase() == "NO") {
        1
    } else if (userInput?.toUpperCase()?.trim() == "EXIT") {
        2
    } else {
        -1
    }
}

fun removeWhiteSpaceBetweenCommaAndNumber(userInput: String): String {
    var modifiedUserInput: String = ""
    userInput.forEach {
        if (it.compareTo(" ".toCharArray()[0]) != 0) {
            modifiedUserInput += it
        }
    }
    return modifiedUserInput
}

fun containDuplicates(userInput: String): Boolean {
    var userInputInList: List<String> = userInput.split(",")
    return userInputInList.distinct().size != userInputInList.size
}

fun removeDuplicates(userInput: String): String {
    var userInputInList: List<String> = userInput.split(",")
    return userInputInList.distinct().joinToString(separator = ",")
}

fun checkForItemsInRange(userInput: String): String {
    var rangeEvaluatedString: String = ""
    var orderedIntListOfUserInput: List<Int> = userInput.split(",").map {
        it.toInt()
    }.sortedBy { it }

    for (x in orderedIntListOfUserInput) {

        if (x < 0) {
            rangeEvaluatedString += x.toString()
            rangeEvaluatedString += " "
        } else {
            break;
        }
    }

    for (x in orderedIntListOfUserInput.asReversed()) {

        if (x >= listOfBranches.size) {
            rangeEvaluatedString += x.toString()
            rangeEvaluatedString += " "
        } else {
            break;
        }
    }

    return putStringsBackToInputOrder(userInput, rangeEvaluatedString.trim())

}

fun putStringsBackToInputOrder(originalUserInput: String, outOfRangeIndexes: String): String {
    var newListInOriginalOrder: MutableList<String> = mutableListOf()
    var mutatingUserInputList: MutableList<String> = mutableListOf()
    var originalUserInputList: MutableList<String> = originalUserInput.split(",").toMutableList()

    outOfRangeIndexes.split(" ").forEach {
        newListInOriginalOrder = mutatingUserInputList

        if (mutatingUserInputList.isEmpty()) {
            mutatingUserInputList.add(it)
        } else {
            for (x in 0 until newListInOriginalOrder.size) {
                if (originalUserInputList.indexOf(newListInOriginalOrder[x]) > originalUserInputList.indexOf(it)) {
                    var indexInList: Int = mutatingUserInputList.indexOf(newListInOriginalOrder[x])
                    mutatingUserInputList.add(indexInList, it)
                    break;
                }
            }
            if (!mutatingUserInputList.contains(it)) mutatingUserInputList.add(it)

        }
    }
    return newListInOriginalOrder.joinToString(",")
}

fun checkForOnlyIntInputs(userInput: String): String {
    var evaluatedString: String = ""
    userInput.split(",").distinct().forEach {
        try {
            it.toInt()
        } catch (e: NumberFormatException) {
            evaluatedString += it
            evaluatedString += " "
        }
    }

    return evaluatedString
}