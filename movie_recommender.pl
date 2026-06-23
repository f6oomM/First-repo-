``:- use_module(library(ansi_term)).
 
/*     Prolog Expert System - Movie Recommender     */

/*     By Fatimah Mohammed     */

/*     TO GET STARTED you just have to write (start.)     */

 /* The first set of FACTs, indicatting the Movie Name with its Genre */
movie("Interstellar",['science fiction',action ,drama,adventure,thriller,astronaut]).
movie("Downsizing",['science fiction',comedy ,drama,adventure]).
movie("Ad Astra",['science fiction',disaster ,drama,adventure,thriller,astronaut]).
movie("The Martian",['science fiction',disaster ,drama,adventure,fantasy,action,astronaut]).
movie("The Truman Show",['science fiction',comedy,fantasy ,drama]).
movie("The Notebook",[romance,comedy,emotional,drama]).
movie("Stowaway",['science fiction' ,action,adventure,thriller,astronaut]).
movie("The Karate Kid",[drama,action,'martial Arts',family,sports,adventure]).
movie("Bird Box",['science fiction',horror ,thriller,drama,'based on books']).
movie("90 Minutes in Heaven",['based on books','based on real life' ,action,emotional]).
movie("Meet Jeo Black",[romance,comedy ,thriller,fantasy,drama]).
movie("Run",[horror ,thriller,adventure,drama]).
movie("I Am Mother",['science fiction',horror ,thriller,action,fantasy]).
movie("Scent of a Woman",[romance,comedy ,action,'based on books',emotional]).
movie("See You Yesterday",['time travel','science fiction' ,action,adventure,thriller,comedy,family]).
movie("The Mountain Between Us",[romance ,action,'based on books',thriller,adventure,emotional]).
movie("The Deep End of the Ocean",[mystery,thriller ,'based on books',drama,emotional,family]).
movie("The Adam Project",['science fiction',comedy ,adventure,action,thriller,family,'time travel']).
movie("Twilight",[romance,horror ,action,'based on books',thriller,fantasy,'science fiction']).
movie("True Spirit",['based on books','based on real life' ,action,adventure,family,sports]).
movie("Society of the Snow",['based on books','based on real life' ,drama,thriller,adventure,family,emotional]).
movie("Hachi: A Dog\'s Tale",['based on real life' ,family,drama,emotional]).

/* The second set of FACTs, indicatting the Movie Name with its Platforms to Watch On */
watchon("Interstellar",[prime, 'apple tv',faselihd]).
watchon("Downsizing",[youtube,prime, 'apple tv']).
watchon("Ad Astra",[prime, 'apple tv']).
watchon("The Martian",[ prime, 'apple tv',faselihd]).
watchon("The Truman Show",['apple tv', youtube]).
watchon("The Notebook",[netflix, prime, 'apple tv', youtube, faselihd]).
watchon("Stowaway",[netflix, prime, 'apple tv', youtube]).
watchon("The Karate Kid",[netflix,'apple tv']).
watchon("Bird Box",[youtube, netflix]).
watchon("90 Minutes in Heaven",[netflix,prime]).
watchon("Meet Jeo Black",[netflix, prime, 'apple tv', faselihd]).
watchon("Run",[netflix, faselihd]).
watchon("I Am Mother",[netflix, prime, 'apple tv']).
watchon("Scent of a Woman",[netflix, prime, 'apple tv', youtube]).
watchon("See You Yesterday",[netflix, youtube]).
watchon("The Mountain Between Us",[netflix, prime, 'apple tv', youtube]).
watchon("The Deep End of the Ocean",[netflix, prime]).
watchon("The Adam Project",[netflix, prime, 'apple tv', faselihd]).
watchon("Twilight",[netflix, prime, 'apple tv', youtube, faselihd]).
watchon("True Spirit",[netflix, prime]).
watchon("Society of the Snow",[netflix]).
watchon("Hachi: A Dog\'s Tale",[netflix, prime, 'apple tv', faselihd]).

/* The third set of FACTs, initializing the Paid Platforms to watch on */
paid_platform(prime).
paid_platform('apple tv').
paid_platform(netflix).

/* The forth set of FACTs, initializing the Free Platforms to watch on */
free_platform(youtube).
free_platform(faselihd).

/* Rule to recommend the Movie based on the Genre */
recommend_by_genre([G|_], Movie) :-
    movie(Movie, Genres),
    member(G, Genres).
recommend_by_genre([_|Rest], Movie) :-
    recommend_by_genre(Rest, Movie).
recommend_by_genre(Genre, Movie) :-
    atom(Genre),
    movie(Movie, Genres),
    member(Genre, Genres).

/* Rule to recommend the Movie based on the Platform */
recommend_by_platform(Platform, Movie) :-
    watchon(Movie, Platforms),
    member(Platform, Platforms).

/* Rule for Paid Platforms */
available_on_paid(Movie) :-
    recommend_by_platform(Platform, Movie),
    paid_platform(Platform).

/* Rule for Free Platform */
available_on_free(Movie) :-
    recommend_by_platform(Platform, Movie),
    free_platform(Platform).

/* Rules to recommend based on Paid or Free Platform */
recommend_by_payment_type(paid, Movie) :- available_on_paid(Movie).
recommend_by_payment_type(free, Movie) :- available_on_free(Movie).

/* Rule to match the emotion tone based on user input */
match_emotion_tone(any, _).
match_emotion_tone([T|_], Movie) :-
    movie(Movie, Tags),
    member(T, Tags).
match_emotion_tone([_|Rest], Movie) :-
    match_emotion_tone(Rest, Movie).
match_emotion_tone(Tone, Movie) :-
    atom(Tone),
    movie(Movie, Tags),
    member(Tone, Tags).

/* Rule to match the pacing based on user input */
match_pacing(any, _).
match_pacing(Pacing, Movie) :-
    movie(Movie, Tags),
    member(Pacing, Tags).

/* Rule to find the movie */
find_movie(Genre, PlatformType, Tone, Pacing, Shown, Movie) :-
    recommend_by_genre(Genre, Movie),
    recommend_by_payment_type(PlatformType, Movie),
    match_emotion_tone(Tone, Movie),
    match_pacing(Pacing, Movie),
    \+ member(Movie, Shown).

/* A block for a colored welcome message */
welcome_screen :-
    ansi_format([bold, fg(cyan)], '===============================================~n', []),
    ansi_format([bold, fg(cyan)], '     WELCOME TO THE MOVIE RECOMMENDATION SYSTEM~n', []),
    ansi_format([bold, fg(cyan)], '===============================================~n~n', []),
    ansi_format([fg(magenta)], 'We will ask you a few questions to recommend the best movie for you.~n', []),
    ansi_format([fg(magenta)], 'Answer honestly and get ready for something you will enjoy!~n~n', []).

/* A block for a colored goodbye message */
goodbye_screen :-
    nl,
    ansi_format([bold, fg(blue)], '===============================================~n', []),
    ansi_format([bold, fg(blue)], '  THANK YOU FOR USING THE MOVIE EXPERT SYSTEM!  ~n', []),
    ansi_format([bold, fg(blue)], '===============================================~n', []),
    ansi_format([fg(magenta)], 'We hope you found a movie worth watching. Enjoy!~n', []).

/* To print the movie recommendation name colored */
print_colored_recommendation(Movie) :-
    nl,
    ansi_format([bold, fg(red)], '>> We recommend: ~w~n', [Movie]),
    ansi_format([fg(green)], 'Enjoy your movie!~n~n', []).

/* THE MOST Important block to start the program */
startexpert :-
    welcome_screen,
    ask_genre(Genre),
    write('Do you prefer paid like [netflix, prime, apple tv] OR free like [youtube, faselIHD] platforms? (paid/free)'), nl,
    read(PlatformType),
    ask_emotion_tone(EmotionTone),
    ask_pacing(Pacing),
    show_recommendations(Genre, PlatformType, EmotionTone, Pacing, []).

/* Rule to show the movie recommendations */
show_recommendations(Genre, PlatformType, Tone, Pacing, ShownMovies) :-
    find_movie(Genre, PlatformType, Tone, Pacing, ShownMovies, Movie),
    print_colored_recommendation(Movie),
    ask_next(Genre, PlatformType, Tone, Pacing, [Movie|ShownMovies]).

show_recommendations(_, _, _, _, _) :-
    write('No more matching movies found for your preferences.'), nl.

/* A loop to ask the user if they want another suggestion */
ask_next(Genre, PlatformType, Tone, Pacing, Shown) :-
    write('Would you like another movie suggestion with the same preferences? (yes/no)'), nl,
    read(Answer),
    (
        Answer == yes -> nl, show_recommendations(Genre, PlatformType, Tone, Pacing, Shown)
        ;
        goodbye_screen
    ).

/*  Questions  */
ask_genre(Genre) :-
    write('What type of experience are you looking for?'), nl,
    write('1. Space or futuristic adventure'), nl,
    write('2. Romance and relationships'), nl,
    write('3. Emotional and real-life stories'), nl,
    write('4. Horror or thrillers'), nl,
    write('5. Martial arts or sports'), nl,
    write('6. Family-friendly or fun adventures'), nl,
    write('7. Fantasy and unusual'), nl,
    write('Enter the number of your choice (1-7): '), nl,
    read(Choice),
    genre_from_choice(Choice, Genre).

genre_from_choice(1, [astronaut,'time travel']).
genre_from_choice(2, romance).
genre_from_choice(3, ['based on real life','based on books']).
genre_from_choice(4, [horror, thriller]).
genre_from_choice(5, [sports, 'martial Arts']).
genre_from_choice(6, [family, adventure]).
genre_from_choice(7, [fantasy,'science fiction']).

ask_emotion_tone(Tone) :-
    write('What emotional tone do you prefer?'), nl,
    write('1. Light and funny'), nl,
    write('2. Deep and emotional'), nl,
    write('3. Suspenseful or thrilling'), nl,
    write('4. Inspiring or motivational'), nl,
    write('5. Does not matter'), nl,
    read(Choice),
    emotion_from_choice(Choice, Tone).

emotion_from_choice(1, comedy).
emotion_from_choice(2, [emotional,disaster]).
emotion_from_choice(3, thriller).
emotion_from_choice(4, ['based on books','based on real life']).
emotion_from_choice(5, any).

ask_pacing(Pacing) :-
    write('What pacing do you prefer?'), nl,
    write('1. Fast-paced and action-filled'), nl,
    write('2. Slow and thoughtful'), nl,
    write('3. No preference'), nl,
    read(Choice),
    pacing_from_choice(Choice, Pacing).

pacing_from_choice(1, action).
pacing_from_choice(2, drama).
pacing_from_choice(3, any).

/*  START to execute the program  */
start :-
    startexpert,
    loop.

/*  LOOP for repeating an action  */
loop :-
    write('Would you like another recommendation? (yes/no)'), nl,
    read(Answer),
    (
        Answer == yes ->
            nl, startexpert
        ;
        Answer == no ->
            goodbye_screen
        ;
        write('Invalid input. Please type yes or no.'), nl,
        loop
    ).
