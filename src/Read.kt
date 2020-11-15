import java.io.File


val pathOfRepository: String = "D:\\Projects\\Quantum\\evd_retailer"

var pathOfApk: String = "$pathOfRepository\\build\\app\\outputs\\apk\\release"

var loginDisplayName: MutableMap<String, String> = mutableMapOf()

var apiReferenceMap: MutableMap<String, String> = mutableMapOf()

var listOfBranches: MutableList<String> = mutableListOf()

var folderNamesFromPathOfRepository = mutableListOf<String>()

var folderNamesFromPathOfRepositoryForBranchSpecific = mutableListOf<String>()

var filesToBeChangedForSpecificCompanies = mutableListOf<String>()

val commitMessage: String = "Version 3.6.2"


fun main(args: Array<String>) {


    folderNamesFromPathOfRepository.addAll(arrayOf("\\lib\\Services", "\\lib\\Components", "\\lib\\Models", "\\lib\\Providers", "\\pubspec.yaml"))


    listOfBranches = getAllBranches()


    fillUpLoginDisplayName(listOfBranches);
    fillApiReferenceMap(listOfBranches);

    var counter: Int = 0;
    mainLoop@ while (counter < listOfBranches.size){

        println("Checking out ${listOfBranches[counter]}")
        when(tryOperation(gitCheckoutBranch, listOfBranches[counter])){
            2 -> {
                break@mainLoop
            }
            1 -> {
                counter+=1
                continue@mainLoop
            }
        }

        // add new changes
        println("Modifying Files")
        val replaceStatus:Boolean = replaceFiles(pathOfRepository, "./src/Changes")
        if(!replaceStatus){
            println("Stopping operation at ${listOfBranches[counter]} branch")
            println("Counter number $counter")
            break@mainLoop
        }

//        println("Replacing Company Files")
//        val replaceStatusForEachCompany:Boolean = replaceBranchSpecificFiles(pathOfRepository, "./src/BranchChanges",listOfBranches[counter]);
//        if(!replaceStatusForEachCompany){
//            println("Stopping operation at ${listOfBranches[counter]} branch")
//            println("Counter number $counter")
//            break@mainLoop
//        }

        // replace company specific changes
        File(pathOfRepository).walkTopDown().forEach {
            companySpecificFileCatcher(it.path)
        }
        filesToBeChangedForSpecificCompanies.forEach {
            fileModifier(it, listOfBranches[counter])
        }

        println("Staging content for ${listOfBranches[counter]}")
        when(tryOperation(gitAddBranch)){
            2 -> {
                break@mainLoop
            }
            1->{
                counter+=1
                continue@mainLoop
            }
        }

        println("Committing content for ${listOfBranches[counter]}")
        when(tryOperation(gitCommitBranch)){
            2 -> {
                break@mainLoop
            }
            1->{
                counter+=1
                continue@mainLoop
            }
        }

        println("Pushing changes for ${listOfBranches[counter]}")
        when(tryOperation(gitPushToOrigin, listOfBranches[counter])){
            2 -> {
                break@mainLoop
            }
            1->{
                counter+=1
                continue@mainLoop
            }
        }

        println("Building flutter apk for ${listOfBranches[counter]}")
        when(tryOperation(flutterBuildApk)){
            2 -> {
                break@mainLoop
            }
            1->{
                counter+=1
                continue@mainLoop
            }
        }

        println("Renaming apk file for ${listOfBranches[counter]}")
        when(tryOperation(renameApk, "${listOfBranches[counter]}-retailer-362")){
            2 -> {
                break@mainLoop
            }
            1->{
                counter+=1
                continue@mainLoop
            }
        }

        println("\n\n Proccess Complete for ${listOfBranches[counter]}")

        counter += 1
    }


}


fun tryOperation(operation: () -> Boolean):Int {
    while (true) {
        val operationStatus:Boolean = operation()
        if(!operationStatus){
            innerLoop@ while(true){
                println("The operation failed, Would you like to try again? \n")
                println("Enter \"Y\" to continue, \"N\" to skip this branch and \"Exit\" to exit the program\n")
                when (confirmFromUser()) {
                    -1 -> {
                        println("Incorrect Input, Please try again")
                    }
                    1 -> {
                        // User wants to skip this branch
                        return 1
                    }
                    2 -> {
                        // User wants to Exit the program
                        return 2
                    }
                    0 -> {
                        println("Retrying the operation\n")
                        break@innerLoop
                    }
                }
            }
        }
        else{
            return 0
        }
    }
}

fun tryOperation(operation: (String) -> Boolean, lamdaParameter:String):Int {
    while (true) {
        val operationStatus:Boolean = operation(lamdaParameter)
        if(!operationStatus){
            innerLoop@ while(true){
                println("The operation failed, Would you like to try again? \n")
                println("Enter \"Y\" to continue, \"N\" to skip this branch and \"Exit\" to exit the program\n")
                when (confirmFromUser()) {
                    -1 -> {
                        println("Incorrect Input, Please try again")
                    }
                    1 -> {
                        // User wants to skip this branch
                        return 1
                    }
                    2 -> {
                        // User wants to Exit the program
                        return 2
                    }
                    0 -> {
                        println("Retrying the operation\n")
                        break@innerLoop
                    }
                }
            }
        }
        else{
            return 0
        }
    }
}

val gitCheckoutBranch: (String) -> Boolean = {
    val process: Process = Runtime.getRuntime().exec("git checkout $it", null, File(pathOfRepository))
    println(process.inputStream.bufferedReader().readText())
    process.waitFor()
    process.exitValue() == 0
}


val gitAddBranch: () -> Boolean = {
    val process: Process = Runtime.getRuntime().exec("git add .", null, File(pathOfRepository))
    println(process.inputStream.bufferedReader().readText())
    process.waitFor()
    process.exitValue() == 0
}

val gitCommitBranch: () -> Boolean = {
    val process: Process = Runtime.getRuntime().exec("git commit -m \"$commitMessage\" ", null, File(pathOfRepository))
    println(process.inputStream.bufferedReader().readText())
    process.waitFor()
    process.exitValue() == 0
}

val gitPushToOrigin: (String) -> Boolean = { branchName: String ->
    val process: Process = Runtime.getRuntime().exec("git push origin $branchName", null, File(pathOfRepository))
    process.inputStream.bufferedReader().forEachLine {
        println(it)
    }
    process.waitFor()
    process.exitValue() == 0
}

val flutterBuildApk: () -> Boolean = {
    val process: Process = Runtime.getRuntime().exec("cmd.exe /C flutter build apk", null, File(pathOfRepository))
    process.inputStream.bufferedReader().forEachLine {
        println(it)
    }
    process.waitFor()
    process.exitValue() == 0
}

val renameApk: (String) -> Boolean = {
    File("$pathOfApk\\app-release.apk").renameTo(File("$pathOfApk\\$it.apk"));
    File("$pathOfApk\\$it.apk").exists()
}



fun companySpecificFileCatcher(source: String) {
    when {
        source.contains("HttpCalls.dart") -> {
            filesToBeChangedForSpecificCompanies.add(source)
        }
        source.contains("login_body.dart") -> {
            filesToBeChangedForSpecificCompanies.add(source)
        }
        source.contains("BluetoothPrinterConnection.dart") -> {
            filesToBeChangedForSpecificCompanies.add(source)
        }
    }
}

fun fileModifier(source: String, branchName: String) {

    var sourceContent: String = File(source).readText()

    when {
        source.contains("HttpCalls.dart") -> {
            sourceContent = sourceContent.replace("test_003", "${apiReferenceMap[branchName]}_003")
            File(source).writeText(sourceContent)
        }
        source.contains("login_body.dart") -> {
            sourceContent = sourceContent.replace("Test EVD", "${loginDisplayName[branchName]} EVD")

            File(source).writeText(sourceContent)
        }

        source.contains("BluetoothPrinterConnection.dart") -> {
            sourceContent = sourceContent.replace("poweredBy = \"Test\"", "poweredBy = \"${loginDisplayName[branchName]}\"")
            File(source).writeText(sourceContent)
        }
    }
}

fun getAllBranches(): MutableList<String> {

    var listOfBranches: MutableList<String> = mutableListOf()
    val process: Process = Runtime.getRuntime().exec("git branch", null, File(pathOfRepository))

    process.inputStream.bufferedReader().forEachLine {


        if (it.contains("*")) {
            if (it.contains("master") || it.contains("test") || it.contains("optimized") || it.contains("experimental")) {

            } else {
                listOfBranches.add(it.removePrefix("*").trim())
            }
        } else if (it.contains("master") || it.contains("test") || it.contains("optimized") || it.contains("experimental")) {

        } else {
            listOfBranches.add(it.trim())
        }
    }

    process.waitFor()
    listOfBranches.remove("tamire")
    listOfBranches.remove("majn")
    listOfBranches.remove("alami")
    listOfBranches.remove("baraki")
    listOfBranches.add(0,"tamire")
    listOfBranches.add(1,"majn")
    listOfBranches.add(2,"alami")
    listOfBranches.add(3,"baraki")

    return listOfBranches
}

fun fillUpLoginDisplayName(branches: MutableList<String>) {
    branches.forEach {
        if (it.equals("actit")) {
            loginDisplayName[it] = "ActIt"
        } else if (it.equals("green")) {
            loginDisplayName[it] = "Green Country"
        } else if (it.equals("medi")) {
            loginDisplayName[it] = "MDT"
        } else if (it.equals("blackDiamond")) {
            loginDisplayName[it] = "Black Diamond"
        } else if (it.equals("tollocash")) {
            loginDisplayName[it] = "TOLLO CASH"
        } else if (it.equals("zehara")) {
            loginDisplayName[it] = "Ze"
        } else if (it.equals("majn")) {
            loginDisplayName[it] = "MAJEN"
        } else if (it.equals("nextstep")) {
            loginDisplayName[it] = "NextStep"
        }else if (it.equals("chadez") || it.equals("inad") || it.equals("mab") || it.equals("mahi") || it.equals("mha") || it.equals("mt") || it.equals("next") || it.equals("mahi") || it.equals("mata") || it.equals("ebyan")) {
            loginDisplayName[it] = it.toUpperCase()
        } else {
            loginDisplayName[it] = it.capitalize()
        }
    }
}

fun fillApiReferenceMap(branches: MutableList<String>) {
    branches.forEach {
        if (it.equals("blackDiamond")) {
            apiReferenceMap[it] = "black_diamond"
        } else if (it.equals("tollocash")) {
            apiReferenceMap[it] = "tolocash"
        } else {
            apiReferenceMap[it] = it
        }
    }
}

fun excludeBranches(branches: MutableList<String>, excludedElementsList: MutableList<String>): MutableList<String> {
    excludedElementsList.forEach {
        branches.remove(it)
    }
    return branches
}

fun buildOnlyThese(branches: MutableList<String>, toBeBuiltBranches: MutableList<String>): MutableList<String> {
    branches.retainAll(toBeBuiltBranches)
    return branches
}

fun replaceFiles(filePathToBeModified: String, filePathOfNewFiles: String):Boolean {

    folderNamesFromPathOfRepository.forEach {
        val deleteStatus:Boolean =  File("$filePathToBeModified$it").deleteRecursively()
        if(!deleteStatus){
            println("$filePathToBeModified$it couldn't be deleted, Please check this file manually or revert" +
                    "the changes using 'git restore .' ")
            return false
        }
        else{
        val copyStatus = File("$filePathOfNewFiles$it").copyRecursively(File("$filePathToBeModified$it"), false)
            if(!copyStatus){
                println("$filePathToBeModified$it couldn't be copied, Please check this file manually or restore" +
                        "the changes using 'git restore .' ")
                return false
            }
            else{
                println("Successfully Copied $filePathOfNewFiles$it")
            }
        }
    }
    return true

}

fun replaceBranchSpecificFiles(filePathToBeModified: String, filePathOfNewFiles: String, branchName: String):Boolean {

    folderNamesFromPathOfRepositoryForBranchSpecific.forEach {
        val deleteStatus:Boolean =  File("$filePathToBeModified$it").deleteRecursively()
        if(!deleteStatus){
            println("$filePathToBeModified$it couldn't be deleted, Please check this file manually or revert" +
                    "the changes using 'git restore .' ")
            return false
        }
        else{
            val copyStatus = File("$filePathOfNewFiles\\$branchName$it").copyRecursively(File("$filePathToBeModified$it"), false)
            if(!copyStatus){
                println("$filePathToBeModified$it couldn't be copied, Please check this file manually or restore" +
                        "the changes using 'git restore .' ")
                return false
            }
            else{
                println("Successfully Copied $filePathOfNewFiles$it")
            }
        }
    }
    return true

}