let Score = JSON.parse(localStorage.getItem('score')) || {
    wins: 0,
    loss: 0,
    tie: 0
};
let result = 'NO MOVE';
let computreMove = 'Not choise yet';
let yourChoose = 'Not choise yet';
updateScore();

function pickRock() {
    computreMove = compChoiceFun();
    yourChoose = 'rock';
    if (computreMove === 'Rock') {
        result = 'tie';
        Score.tie += 1;
    } else if (computreMove === 'Paper') {
        result = 'Computer win';
        Score.loss += 1;
    } else {
        result = 'You win';
        Score.wins += 1;
    }
    localStorage.setItem('score', JSON.stringify(Score));
    updateScore();
}

function pickPaper() {
    computreMove = compChoiceFun();
    yourChoose = 'Paper';
    if (computreMove === 'Paper') {
        result = 'tie';
        Score.tie++;
    } else if (computreMove === 'Rock') {
        result = 'you win';
        Score.wins++;
    } else {
        result = 'Computer win';
        Score.loss++;
    }
    localStorage.setItem('score', JSON.stringify(Score));
    updateScore();

}

function pickScissor() {
    computreMove = compChoiceFun();
    yourChoose = 'Scissor';
    if (computreMove === 'Scissor') {
        result = 'tie';
        Score.tie++;
    } else if (computreMove === 'Rock') {
        result = 'Computer win';
        Score.loss++;
    } else {
        result = 'You win';
        Score.wins++;
    }
    localStorage.setItem('score', JSON.stringify(Score));
    updateScore();

}

function resetScore() {
    Score.wins = 0;
    Score.tie = 0;
    Score.loss = 0;
    localStorage.removeItem('score');
    updateScore();
}

function compChoiceFun() {
    let compChoice = '';
    let randomNumber = Math.random();
    if (randomNumber >= 0 && randomNumber < 1 / 3) {
        compChoice = 'Rock';

    } else if (randomNumber >= 1 / 3 && randomNumber < 2 / 3) {
        compChoice = 'Paper';
    } else if (randomNumber >= 2 / 3 && randomNumber < 1) {
        compChoice = 'Scissor';

    }
    return compChoice;
}

function updateScore() {
    document.querySelector('.js-status').innerHTML = `${result}`;
    document.querySelector('.js-picked-moves').innerHTML = `Computer choose: ${computreMove} Your choose: ${yourChoose} `;
    document.querySelector('.js-score').innerHTML =
        ` Wins: ${Score.wins} tie: ${Score.tie} Loss: ${Score.loss}`;

}