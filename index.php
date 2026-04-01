<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">

<head>
    <meta charset="utf-8" />
    <meta name="keyword" content="Timothé Pellen, Pellen, Timothé, Informatique, STI2D, IUT, Lannion, BUT, Étudiant, Développeur, Programmation, C, SQL, HTML, CSS, Projets, Portfolio, BTS, SIO, BTS SIO" />
    <title>Timothé PELLEN</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="asset/css/style.css" > 
    <link rel="icon" type="image/png" href="asset/images/logo site (1).png" />
    <script src="javascript/parallaxe.js"></script>
</head>

<body>
    <?php require_once 'header.php'; ?>
    <main class="link">
        <div class="bg sombre" id="para">
            <article>
                <div class="horizon">
                    <img src="asset/images/94.jpg" alt="Moi" height="400" class="rond . tete">
                    <h1>Timothé PELLEN</h1>
                </div>
                <h5>Je suis étudiant à l'IUT de Lannion en BUT informatique première année. <br>
                J'ai un BAC STI2D avec option SIN (systèmes d'information et numérique) obtenu à St Sébastien à Landerneau en juin 2023.</h5>
                <a href="asset/download/CV.pdf" download>CV</a>
            </article>
        </div>

                <article>
                    <h2>Compétences acquises</h2>
                    <h3 class="normal">Durant mes études, j'ai participé à des projets tous très intéressants qui m'ont apporté <br>
                    En voici la liste :</h3><br>
                </article>

            <article class="row">
                <h3 class="col-12">Réalisation d'un développement d'application</h3>
                <article class="col-12 col-lg-6 projets">
                    <p><strong>L'objectif :</strong> créer un jeu de Sudoku de n'importe quelle dimension de grille en langage C jouable sur terminal.</p>
                    <a href="sudoku.html" class="boutton">le code</a><br>
                    <img class="demo" src="asset/images/S1.01sudoku.png" alt="sudoku">
                </article>
                <article class="col-12 col-lg-6 projets">
                    <p><strong>L'objectif :</strong> créer un jeu de snake avec des pavées et des trous qui téléporte le serpent en langage C jouable sur terminal.</p>
                    <a href="snake.html" class="boutton">le code</a><br>
                    <img class="demo" src="asset/images/S1.01snake.png" alt="snake">
                </article>
            </article>
            <article class="row">
                <h3 class="col-12">Optimisation des applications informatiques</h3>
                <article class="col-12 col-lg-6 projets">
                    <p><strong>L'objectif :</strong> créer un résolveur de Sudoku à partir du programme précédemment créé.</p>
                    <a href="Backtracking.html" class="boutton">le code</a><br>
                    <img class="demo" src="asset/images/sae1.02.png" alt="Backtracking">
                </article>
                <article class="col-12 col-lg-6 projets">
                    <p><strong>L'objectif :</strong> créer un snake qui va chercher ses pommes automatiquement à partir du programme de snake déjà fait précédemment</p>
                    <a href="autoSnake.html" class="boutton">le code</a><br>
                    <img class="demo" src="asset/images/sae1.02snake.png" alt="snake automatique">
                </article>
            </article>
            <div>
                <article class="row">
                    <h3 class="col-12">Installation d'un poste pour le développement</h3>
                    <article class="col-12 projets">
                        <p><strong>L'objectif :</strong> réaliser un programme qui permet de créer la documentation d'un fichier écrit en langage C, en HTML et Markdown grâce à du PHP.</p>
                        <a href="Docker.html" class="boutton">explication</a><br>
                        <img class="demo" src="asset/images/sae1.03.png" alt="Documentation">
                    </article>
                </article>
            </div>
            <div>
                <article class="row">
                    <h3 class="col-12">Création d’un site Web</h3>
                    <article class="col-12 col-lg-6 projets">
                        <p><strong>L'objectif :</strong> créer un site web par groupe de 4 pour une entreprise factice créant du contenu de streaming pour une série au choix. Notre groupe a choisi Scooby-Doo.</p>
                        <a href="S1.05 old/Backstage.html" class="boutton">ma page</a><br>
                        <img class="demo" src="asset/images/S1.05scooby-doo.png" alt="HTML">
                    </article>
                    <article class="col-12 col-lg-6 projets">
                        <p><strong>L'objectif :</strong> créer un site web par groupe de 4 pour les Jeux Olympics et plus présisément sur une disipline au choix.</p>
                        <a href="SAE1.05/Discipline.html" class="boutton">ma page</a><br>
                        <img class="demo" src="asset/images/S1.05volley-ball.png" alt="HTML">
                    </article>
                </article>
            </div>
            <div>
                <article class="row">
                    <h3 class="col-12">Création personnels</h3>
                    <article class="col-12 col-lg-6 projets">
                        <p>J'ai créer un petit jeu de labyrinth seul pour mon été 2025.</p>
                        <a href="S1.05 old/Backstage.html" class="boutton">ma page</a><br>
                        <img class="demo" src="asset/images/S1.05scooby-doo.png" alt="HTML">
                    </article>
                    <article class="col-12 col-lg-6 projets">
                        <p><strong>L'objectif :</strong> créer un site web par groupe de 4 pour les Jeux Olympics et plus présisément sur une disipline au choix.</p>
                        <a href="SAE1.05/Discipline.html" class="boutton">ma page</a><br>
                        <img class="demo" src="asset/images/S1.05volley-ball.png" alt="HTML">
                    </article>
                </article>
            </div>
        </section>
        
        
    </main>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>