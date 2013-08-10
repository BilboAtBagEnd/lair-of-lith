function capitalizeFirstLetter(string) {
    if (string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    } else {
        return string;
    }
}

function capitalizeWords(string) {
    if (string) {
        var words = string.split(/ +/);
        var capWords = [];
        for(var i = 0; i < words.length; i++) {
            capWords.push(capitalizeFirstLetter(words[i]));
        }
        return capWords.join(" ");
        
    } else {
        return string;
    }
}

function splitOnCommas(s) {
    var splitResult = s.split(/\s*,\s*/);
    if (splitResult.length == 1 && splitResult[0] == "") { 
        return [];
    } else {
        return splitResult;
    }
}

function sanify(string) {
    return string.replace(/[^A-Za-z 0-9]/, "");
}
