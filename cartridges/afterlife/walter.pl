% SPDX-License-Identifier: 0BSD
% The reel of Walter Alder: a long conversation, written by hand, to find out how much like talking
% a recorded conversation can be. Walter is invented. Every line that is not a comment is a fact,
% and a reel holds nothing else.
%
% How it is put together (DESIGN.md, section 11):
%
%   A head is an answer that stands by itself, to a question that makes sense anywhere: where he
%   grew up, what Grandma was like. Any answer may lead to a head, in the head's own words.
%
%   A thread hangs under a head. An answer in a thread leans on what was said before it: he says
%   "he" and means his father, or "same house, same year". So a thread is entered from above and
%   from nowhere else. The reel says what each such answer needs (tells and needs, near the end),
%   and the compiler will not compile it if a visitor can come to an answer without.
%
%   A visitor's line need not be a question. He asks things, and "Yes." and "Not so good." are
%   answers he can answer. The same line can mean different things in different places:
%   "Tell me more.", "I'm sorry.", "What did Grandma say?" and "Tell me another." all do.
%
% No test holds a word of this reel. Change a line to what was really said, and nothing else moves.

reel(1).
speaker("Walter Alder").
about("1941 – 2026").
language(en).
opening(hello).

% generated(Line): this reel was generated, and says so in these words, which the compiler writes
% into reel.json and README.txt. A reel of a person's own recordings has no such line.

generated("A demonstration: Walter Alder is invented, and his words and his voice were generated.").

% response(Name, Said): something he says. Its recording is in masters/, under the same name.

% Arriving.

response(hello, "Hello, kiddo. I'm glad you came by. Sit down a minute. What would you like to know?").

response(keeping, "Me? Oh, I'm past complaining. Your grandmother would have called that the first miracle. Never mind me. How are you? And don't say fine. Everybody says fine. How are you, really?").

response(doing_well, "Good. That's all I ever wanted to hear out of any of you. All right is plenty. Now. You didn't come all this way to talk about the weather. Ask me something.").

response(not_so_good, "No. I thought it might be that. Well. Sit there a minute, then. You don't have to tell me the whole of it. Just this much. Is it your heart that's hurting, or is it everything at once?").

response(heartache, "Ah. That's the bad one. Nobody can see it, and you still have to go to work in the morning. I can't fix it, kiddo. I can tell you it hurts about as much as the thing was worth. So it must have been worth a good deal.").

response(heartbroken, "Once, before your grandmother. A girl named Marjorie. She wrote to me in Germany to say she'd met a dental student. I moped for most of a year. I wrote poems. Then one night my sister dragged me to a dance at the Grange hall, and that was the end of Marjorie.").

response(poems, "I did. Eleven of them. One rhymed Marjorie with margarine, and that was the best of the lot. Your grandmother found them in a shoebox in nineteen seventy and read them out loud at supper. All eleven. With feeling. She recited the margarine one at me for the next forty years.").

response(everything, "Then don't fix everything at once. Pick the smallest thing. Wash one dish. I mean it. I had six hundred mailboxes on my route, and I never once delivered six hundred boxes. I delivered one. And then the next one.").

% Maple Street.

response(maple, "I grew up on Maple Street, in a house my father built with his two brothers. It had a porch that ran all the way around, and on hot nights we slept out there, all five of us, lined up like loaves of bread.").

response(five, "My mother and father on the outside, to keep us from rolling off. Ray, the oldest. Dot, the baby. And me in the middle, getting kicked from both sides. It's good training. You learn early that nobody's going to hand you the blanket.").

response(ray, "Ray was three years older, and he never let me forget a day of it. He jumped off the porch roof with an umbrella once, to see if it would work. It did not work. He wore a cast all summer and made me scratch inside it with a knitting needle. Did you ever do anything that dumb?").

response(dumb_yes, "Good. I never trusted a person who hadn't jumped off something. Don't tell your mother I said so.").

response(dumb_no, "Hm. Well, there's still time. But not with an umbrella. We've settled the umbrella.").

response(ray_fight, "Like two cats in a sack, until I was eighteen. Then he came to the bus station the day I left for the Army, and he shook my hand, like I was a man he'd just met. We never had a cross word after. I think we'd used them all up.").

response(ray_gone, "He joined the Navy, and then he sold insurance in Tucson for forty years, which he said was the same job with less water. We lost him in two thousand nine. I gave the eulogy. I told about the umbrella, and the whole church laughed, and I thought, well, Ray. It finally worked.").

response(sorry_ray, "Don't be. He had a good long run. I do miss the arguing, though. Nobody else alive knows what I was like at nine. Well. Dot does. But she's too polite to bring it up.").

response(dot, "Dot was the smart one. She'd read every book in the town library by the time she was fourteen, and then she started over, in case she'd missed something. She's the one to ask about all this. She remembers everything I've got wrong.").

response(dot_wrong, "Oh, she keeps a list. The porch only ran around three sides. My father had one brother helping, not two. And I never slept in the middle. I slept on the end, by the steps, because I snored. Go and ask her yourself, kiddo, while you can. And don't tell her I called her the smart one.").

response(mother, "Loud, in the best way. My father could go a whole day on ten words. She'd use ten before she had her apron tied. She sang while she worked, and she sang flat, and not one of us ever told her. She's the one who taught me to make a pie.").

response(mother_sang, "Hymns, mostly. And one waltz. Let Me Call You Sweetheart. She'd come up on the high part and miss it by a mile, every time, and sail right on. I was twenty years old before I found out that wasn't how the song goes.").

% He sings the middle paragraph: two lines of a waltz of 1910.

response(song, "Oh, no. No, no. Well. All right. Once.\n\nLet me call you sweetheart, I'm in love with you. Let me hear you whisper that you love me too.\n\nThere. That's all you get. And you'll notice I missed the high part. So did my mother, every time. It runs in the family.").

response(song_rest, "No. The rest was your grandmother's. You get two lines and a story, and that's a fair price.").

response(song_voice, "I have a loud voice. It's not the same thing. But thank you for lying to an old man.").

response(bake, "She did. I was the only one who'd stand still in a kitchen. My brother was out breaking something, my sister had her nose in a book, and I was hungry. So I stayed. She'd say, hands out of the bowl, Walter. Cold hands, cold butter, and leave it be.").

response(house, "It's still standing. Somebody painted it yellow, which he would have hated. But the porch is the same. I used to drive by every few years, just to look at it.").

response(house_knock, "Once. I knocked, and a young woman let me walk through. They'd taken out the wall between the kitchen and the front room. He was proudest of that wall. I told her it looked very nice. Then I sat in the car a good while. I never knocked again.").

response(rose_house, "She said, Walter, you can't go home again, they've painted it. And then she drove me past one more time anyway, slow, so I could look. That was her all over. The remark first, and then the kindness, quick, so you wouldn't catch her at it.").

response(house_sad, "A little. But a house is supposed to get used. He'd have hated the yellow, and he'd have hated the wall, and then he'd have asked whether the roof leaked. It doesn't. I asked.").

% His father.

response(father, "My father was a carpenter. He smelled of cedar and pipe smoke, and he could not walk past a crooked picture without straightening it. He didn't say much. He'd fix your chair, and that was how you knew.").

response(father_knew, "That he'd noticed you. That was the whole language. I never heard him tell any of us he loved us, not once. But I never sat down in a chair in that house that wobbled.").

response(father_bother, "When I was young, it did. I wanted the words. Then I had a child of my own, and I found out how hard the words are to get out past your teeth. So I've tried to say them more than he did. I love you, kiddo. There. That's one he never managed, and it only took me eighty years.").

response(love_too, "I know you do. You came, didn't you.").

response(workshop, "He had a workshop out back, and I wasn't allowed in it, so of course I was in it all the time. He kept a stool for me by the vise. He never once said I could stay. He just kept the stool there.").

response(not_carpenter, "I tried. I worked on his crew the summer I was seventeen, and I was a disgrace. I could measure twice, cut once, and still be wrong. He never said a word. He just started giving me the jobs where it didn't matter. Carrying things, mostly. That's how I found out I was good at carrying things.").

response(father_mind, "If he did, he fixed something instead of saying so. But the day I got the mail route, he came by with a rack he'd built for my mail trays. Scrap oak. Dovetailed. For mail trays. That was him telling me it was all right.").

response(rack, "Your mother has it. She keeps boots in it. He'd have liked that. A thing ought to get used.").

% The pie.

response(pie, "More butter than you think, less sugar than you think, and don't fuss with the dough. A crust that's been fussed over comes out tough. Same as children.").

response(children, "Same as children. You can't knead a person into shape. I tried it with your mother the year she was fifteen, and all I got was a tougher crust on both of us. Rose told me to take my hands out of the bowl. She was right. She was nearly always right, which is a hard thing to live with.").

response(pie_taught, "My mother, on Maple Street. And then the Army untaught me. I told a sergeant I could bake, and he handed me a recipe that started with ninety pounds of flour. You have not lived until you've cracked eggs into a garbage can. A clean one. Mostly clean.").

% The Army.

response(army, "Two years. Fifty-nine to sixty-one. There wasn't a war on, which is the best time to be in an army. They sent me to Germany and stood me in a kitchen. I defended the free world with a potato peeler, and I'd like it noted that the free world is still there.").

response(germany, "Cold. And everything was older than anything I'd ever seen. There was a church in that town that went up before Columbus sailed, and people just walked past it to buy bread. I stood in front of it for an hour, like a fool, holding a sack of onions.").

response(germany_back, "No. Rose and I always said we would, once the route was done. Then the route was done, and we said next year. Go where you mean to go, kiddo. Next year isn't a place.").

response(homesick, "Something awful. I've never said so until now. I wrote my mother every Sunday and told her the food was fine, and I was the one cooking it. She wrote back every week. Four pages. And the last line was always the same. Come home hungry.").

response(came_home, "I did. I got off the bus in March of sixty-one, and she had a pie on the table before I had my coat off. And that October my sister dragged me to a dance at the Grange hall. So you could say everything good that ever happened to me started with being hungry.").

% The mail route.

response(route, "Thirty-four years. A hundred and twelve miles a day, six hundred mailboxes. I drove a Jeep with the wheel on the wrong side, and I still reach for the door on the right. I knew who was sick, and who was in love, and who was behind on the electric. A mailman knows everything, kiddo. A good one says nothing.").

response(secrets, "Ha. Nice try. I kept all that for thirty-four years, and I'm not about to start talking now. I will say there was a man out on Mill Road who got a letter from the same woman every week for eleven years. They were both married, and not to each other. And that's all you get.").

response(secrets_no, "No.").

response(secrets_never, "Still no. You get that from your grandmother. She asked me every night at supper for fifty years, and I never told her either. I'll talk about the dogs all day long. But not that.").

response(route_like, "I loved it, and I didn't expect to. I took it because Rose was expecting and the lumber yard was laying off. But there's a thing that happens when you bring somebody the letter they've been waiting on. They come down the drive before you've stopped the Jeep. I got to be that, six days a week.").

response(route_best, "Mrs. Pruitt, nineteen seventy-two. She met me at her box every single day for a year, waiting on a letter from her boy overseas. One morning I had it. I didn't put that one in the box. I got out and walked it up to the porch. There's a regulation against crying on the route, so I held off until I got around the bend.").

response(route_worst, "Same house. Same year. A different kind of news. An officer got to the door ahead of me, so at least I wasn't the one who carried it. I brought her the regular mail the next morning, same as always. I didn't know what else to do. And she came down to the box anyway. I think she needed one thing to still be the same.").

response(route_said, "Nothing clever. I said, morning, Mrs. Pruitt. And I said it every morning for the next twenty years. Sometimes that's the whole job, kiddo. You just keep showing up at the box.").

response(dogs, "Were there dogs. Thirty-four years of dogs. I was bitten four times, chased more than I can count, and loved by exactly one. The Hendersons had a collie named Lady. She bit me my first week, clean through the trouser leg. Then she waited for me at the end of that drive every day for nine years. I think she felt bad about it.").

response(lady, "She got old. One morning she wasn't at the end of the drive, and I knew before I got to the box. Henderson had left me a note in it. All it said was, Walt, she waited as long as she could. I kept that note in the Jeep until the Jeep gave out.").

response(sorry_lady, "So was I. Nine years is a long friendship, for a dog and a mailman.").

response(biscuit, "We had Biscuit. A beagle, more or less. Your mother found him behind the feed store and carried him home inside her coat. Rose said absolutely not. He lived with us fourteen years. On Saturdays he rode the route with me, sitting up in the other seat like he was driving.").

response(rose_biscuit, "She said, that dog is not sleeping in this house. He slept on her feet for fourteen years. When he died, she cried harder than I did, and she said, no more dogs. Then she fed every stray in the county off the back step until the day she died.").

% Rose.

response(rose, "At a dance at the Grange hall, in nineteen sixty-one. I stepped on her foot twice and apologized three times. She said, well, at least you can count.").

response(band, "Let Me Call You Sweetheart. Every band played it. It's a waltz, and I can't waltz, which is how I came to be standing on her foot. I've had a soft spot for that song for sixty years.").

response(wearing, "Now, that I ought to know, and I don't. Blue, I want to say. Rose always said it was green, and that I'd been telling it wrong for fifty years. So. Green. Put down green.").

response(not_how, "No, I don't suppose it is. In her telling, I stepped on her foot four times, and she counted them off out loud. She's not here to argue it, so you'll have to take mine. Though hers was the better story. Hers usually was.").

response(proposal, "I never did propose, exactly. I said, I suppose we ought to get married. And she said, I suppose we ought. And that was fifty-one years.").

% "As you've heard": he leans on the dance, which every way here has passed.

response(married, "You don't keep score. I can count, as you've heard, but I never counted that. Who got up with the baby. Who said sorry last. The day you start a tally, you've got a business, not a marriage. That, and she was funnier than I was. It's hard to stay mad at somebody who's funnier than you.").

response(fights, "Twice a year, like the time change. Mostly about money. And once, for three days, about a lawn mower. I won't go into the lawn mower.").

response(mower, "Nineteen eighty-one. I bought a riding mower without asking, for a yard you could have cut with scissors. Three days we didn't speak. She was right, and I knew it by the second day, and I held out for the third on principle. That mower never did run right.").

response(rose_mower, "She said, Walter, I can wait. And she could. That is a terrible thing to hear from a woman who can add.").

response(rose_like, "Quick. She kept the books at Hadley's feed store, and she could run a column of figures in her head faster than the adding machine. She'd finish my sentences, and improve them. And she laughed with her whole face. You have her laugh, you know. The first time I heard it out of you, it about knocked me over.").

response(rose_story, "All right. A man came down from the state once to go over Hadley's books, and he told her she was off by eleven cents. She took the ledger out of his hands. Four minutes. The mistake was his. She said, you owe Mr. Hadley eleven cents. And he paid it, out of his own pocket. Hadley kept that dime and that penny in a frame by the register.").

response(rose_story2, "Greedy. All right. The night your mother was born, I fainted. Not in the room. In the hallway, on my way to the room. So Rose had the baby, and then she had the nurses wheel me in on a cart, so she could get a look at me. She said it was the best laugh she ever had with stitches in.").

response(rose_story3, "No. I've got to save a few, or you won't come back.").

response(rose_died, "Quiet. That's the part nobody tells you. Fifty-one years of somebody humming in the next room, and then the house just stops. I kept setting out two cups. I did that for most of a year. I wasn't confused. I knew. I just wasn't ready to set out one.").

response(through_it, "Badly, at first. I didn't eat right, and I quit answering the phone. Then your mother showed up at the door with a suitcase. She didn't ask. She just started making supper. So I ate something. And the next day I went outside. That's all I know to tell anybody. Eat something. Go outside. Let somebody who loves you in the door. I'm just the one it worked on.").

response(miss_rose, "Every day, about four in the afternoon. That's when she'd come home from Hadley's and tell me what everybody in the county was buying, and why they shouldn't. It's the quietest part of the day now. So that's when I take my walk. You have to put something in the hole, or you just stand there looking down it.").

response(sorry_rose, "I know. So am I. But I had fifty-one years. Some people get the wrong one for fifty-one years, and some get the right one for five. I'm not about to complain to the management.").

% The family.

response(happy, "All right. Here's one. Every one of you grandkids, when you were small, fell asleep on my chest out on the porch, one time or another. And I would not move. Not for the telephone. Not for supper. Rose would come out and say, Walter, your arm's gone white. And I'd say, shh. Best seat I ever had.").

response(little_you, "Loud. You came into a room like a marching band. And you asked why about everything. Why is the sky. Why is the dog. You never waited for the answer. You were already on to the next one. And look at you now. Still here, asking the old man questions.").

response(mom_little, "Stubborn as a gatepost. When she was four, she decided she was through with shoes, and she didn't wear a pair from May until the first frost. Rose fought her on it for a week, and then said, fine. Let her feet argue with the gravel. If you've ever lost an argument with your mother, I want you to know it wasn't a fair fight. I never won one either.").

response(good_father, "I was a tired one. Out the door at five every morning, and asleep in the chair by eight. I missed things. A recital. Most of a softball season, one year. I've told your mother I was sorry, and she says there's nothing to forgive, which is kind, and isn't true. If you get the chance to be there, be there. They don't hold the recital twice.").

% Comfort.

response(sad, "Oh, kiddo. First, eat something. You'd be surprised. Then go outside, even if it's raining. Especially if it's raining. And then call somebody who loves you. I'd say call me, but this will have to do.").

response(sad_works, "It doesn't fix a thing. It just gets you to tomorrow with something in your stomach, and tomorrow is the one that does the fixing. I didn't believe it either. Then Rose died, and I found out.").

response(miss, "I know, kiddo. I know. I'd give a good deal to be sitting across from you right now, and not whatever this is. But listen. You're hearing my voice, and I picked every word of it for you. That's not nothing. That's about as close as I could figure out how to get.").

response(not_same, "No. It isn't. I'm not going to tell you it is. I never lied to you when I could look at you, and I'm not going to start now that I can't. It isn't the same. But stay a while anyway.").

response(love_you, "I love you too, kiddo. More than I ever said. And I said it more than my father did, so that's a good deal.").

response(would_miss, "Coffee. The first cup, before anybody else is up. And the sound of all of you talking at once at Thanksgiving, and nobody listening to anybody. I used to sit at the end of the table and not say a word, just to hear it. You all thought I was going deaf. I was just happy.").

% The large questions.

response(regrets, "A few. I never took Rose to see the ocean. A hundred and twelve miles a day, and I couldn't find one weekend to drive her to the water. And there are things I'd have liked to say to my father while he could hear them. But it's a short list. I went over it carefully before I sat down to record all this. It's a short list, kiddo, and you're not on it.").

response(ocean, "There was always the route. Six days a week, and on the seventh the gutters wanted cleaning. I thought there'd be time after. That's the oldest mistake there is, and I walked right into it. Take the trip. The gutters will wait.").

response(father_unsaid, "That I saw it. The chairs he fixed, and the rack he built me, and the stool he kept by the vise. I knew what every bit of it meant, and it was enough. I think he believed he'd gone his whole life without saying anything. I'd have liked to tell him I heard every word.").

response(afraid, "Less than I thought I'd be. I was afraid of it at forty. At eighty-four, it's more like the last stop on the route. You've been driving all day, and you're tired, and the light's getting long. I'm in no hurry. But I'm not afraid of the last box. I'm only hoping somebody's waiting at the end of the drive.").

response(waiting, "Your grandmother, first. Tapping her foot, I expect, and wanting to know what took me so long. And a collie I knew on the route, if they let dogs in. If they don't let dogs in, I'm not certain I want to go.").

response(heaven, "I believe in your grandmother, and she believed in heaven, so I've decided to go along with her. She was right about the lawn mower, and the price of corn, and every person she ever met inside of five minutes. I'd be a fool to start doubting her now.").

% What a visitor brings: trouble, and news.

response(advice, "Well. You've come to a man with a great many opinions and no way of checking up on you, so that's ideal. What kind of trouble is it? Love, or work, or money?").

response(advice_love, "Then here's all I know. Pick the one you can be quiet with. Anybody is good company at a dance. You want the one you can drive four hours beside and never reach for the radio. And if you've already picked, and it's gone hard, say the thing you're not saying. It's nearly always the thing you're not saying.").

response(advice_work, "Do the job in front of you, and do it the same whether anybody's watching or not. Somebody's always watching anyhow. Usually a dog. And don't mistake the job for yourself. I was a mailman for thirty-four years, and then one Friday I wasn't, and I was still there Saturday morning. That surprised me.").

response(retire, "The first month, I woke up at half past four every morning and sat in the kitchen in my uniform pants. Rose finally handed me a list. Thirty-one jobs around the house, numbered. She said, there's your route. It took me two years, and I believe she'd been saving some of those since nineteen seventy.").

response(advice_money, "Rose is the one to ask, and here's what she'd tell you. Write it down. Every dollar, and where it went. Not to scold yourself. Just so it can't sneak off. She said most money trouble isn't the big things. It's the leaks. And never lend to family. Give it, or don't.").

response(lend, "Because I lent my brother four hundred dollars in nineteen sixty-eight, and neither of us mentioned it again for forty years. It rode along on every telephone call like a third party on the line. I should have just given it to him. It was only ever worth four hundred dollars, and I let it cost a good deal more.").

response(news, "News! Well, don't just stand there. Is it the good kind, or the other kind?").

% In the next two, the line that is only an ellipsis is a silence of some five seconds, kept in the
% recording: it is the visitor's turn to speak.

response(news_good, "I was hoping. Go on, then, and say it. Out loud. I can't hear you from where I am, but say it anyway. I've got time.\n\n…\n\nWell, now. How about that. I don't need the particulars to be proud of you, kiddo. I already was. Now go and tell somebody who can hug you for it.").

response(news_bad, "Ah. All right. Go ahead and say it, then. Out loud, all the way to the end. I'm not going anywhere.\n\n…\n\nThat's a hard one, and I'm sorry. I'd fix it if I could, and I never could fix the big ones, even when I was there. But you said it out loud, and you got to the end of it. That's the first part done.").

% Lightness.

response(joke, "All right. A man on my route says to me, Walter, do you read my postcards? I said, sir, that would be against regulations. He says, good. And I said, but your sister's wrong about the casserole.").

response(joke_terrible, "It is. I told that joke at the post office Christmas party thirty-four years running, and nobody laughed. Not once. You don't tell a joke like that for the laugh. You tell it so they'll all groan together. It's the only choir I was ever in.").

response(joke_another, "I've only got the one. Rose had all the good ones. She could tell a joke at a funeral and get away with it. She told one at her own, more or less. She left a note for the minister. It said, keep it short, Walter gets hungry.").

% Thanksgiving, and leaving.

response(proud, "That all of you still come home for Thanksgiving, and nobody has to be asked twice. I didn't build a house, like my father did. But I think I built that.").

response(thanksgiving, "Twenty-some people in a house built for three. Two tables and a card table, and the card table's the one you want. That's where the trouble is. I carve, badly. Somebody always brings a pie to compete with mine, and nobody touches it, out of loyalty. And about four o'clock it gets so loud I can't hear myself think. That's the part I like best.").

response(carve, "You are. I'm appointing you. The knife is in the drawer left of the stove, and it has never once been sharp, so don't blame yourself. Cut it thick. Nobody ever complained about a thick slice. And say something before you start. It doesn't have to be a prayer. Just tell them you're glad they came.").

response(leaving, "Already? Well. I won't keep you. You've got a life to get back to, and that's as it should be. Thank you for coming. I mean that. It's a long way to come to hear an old man repeat himself.").

response(goodbye, "Only that I loved every one of you, even when you tracked mud in. Go on, now. Turn off the light on your way out. And come back and see me.").

response(come_back, "I know you will. I'll be right here. I'm not going anywhere, kiddo. That's one promise I can still keep.").

response(goodnight, "Goodnight, kiddo. Go easy on yourself. And eat something.").

% When a question has no answer.

response(unsure, "Hm. I don't believe anyone asked me that while I could still answer. Try me on something else.").

response(unsure_too, "That one I'll have to leave a mystery, kiddo. Ask me another.").

% answers(Name, Question): what he was answering, word for word as it was put to him.

answers(keeping,       "How are you, Grandpa?").
answers(doing_well,    "I'm doing all right.").
answers(not_so_good,   "Not so good.").
answers(heartache,     "My heart.").
answers(heartbroken,   "Did you ever have your heart broken?").
answers(poems,         "You wrote poems?").
answers(everything,    "Everything at once.").

answers(maple,         "Where did you grow up?").
answers(five,          "Who were the five of you?").
answers(ray,           "Tell me about Ray.").
answers(dumb_yes,      "Yes.").
answers(dumb_no,       "No.").
answers(ray_fight,     "Did you two get along?").
answers(ray_gone,      "What happened to Ray?").
answers(sorry_ray,     "I'm sorry.").
answers(dot,           "Tell me about Dot.").
answers(dot_wrong,     "What would she say you got wrong?").
answers(mother,        "What was your mother like?").
answers(mother_sang,   "What did she sing?").
answers(song,          "Sing it for me.").
answers(song_rest,     "Sing the rest.").
answers(song_voice,    "You have a nice voice.").
answers(bake,          "She taught you the pie?").
answers(house,         "What happened to the house?").
answers(house_knock,   "Did you ever go inside?").
answers(rose_house,    "What did Grandma say?").
answers(house_sad,     "That's sad.").

answers(father,        "Who was your father?").
answers(father_knew,   "How you knew what?").
answers(father_bother, "Did that bother you?").
answers(love_too,      "I love you too.").
answers(workshop,      "Tell me more.").
answers(not_carpenter, "Were you a carpenter too?").
answers(father_mind,   "Did he mind?").
answers(rack,          "Do you still have it?").

answers(pie,           "How do you make your apple pie?").
answers(children,      "Same as children?").
answers(pie_taught,    "Who taught you?").

answers(army,          "You were in the Army?").
answers(germany,       "What was Germany like?").
answers(germany_back,  "Did you ever go back?").
answers(homesick,      "Were you homesick?").
answers(came_home,     "Did you?").

answers(route,         "Tell me about the mail route.").
answers(secrets,       "What did you know?").
answers(secrets_no,    "Come on.").
answers(secrets_never, "Please?").
answers(route_like,    "Did you like it?").
answers(route_best,    "What was the best day?").
answers(route_worst,   "And the worst day?").
answers(route_said,    "What did you say to her?").
answers(dogs,          "Were there dogs?").
answers(lady,          "What happened to Lady?").
answers(sorry_lady,    "I'm sorry.").
answers(biscuit,       "Did you have a dog of your own?").
answers(rose_biscuit,  "What did Grandma say?").

answers(rose,          "How did you meet Grandma?").
answers(band,          "What was the band playing?").
answers(wearing,       "What was she wearing?").
answers(not_how,       "That's not how Grandma told it.").
answers(proposal,      "Tell me more.").
answers(married,       "How did you stay married that long?").
answers(fights,        "Did you ever fight?").
answers(mower,         "What lawn mower?").
answers(rose_mower,    "What did Grandma say?").
answers(rose_like,     "What was Grandma like?").
answers(rose_story,    "Tell me a story about her.").
answers(rose_story2,   "Tell me another.").
answers(rose_story3,   "Tell me another.").
answers(rose_died,     "What was it like, losing her?").
answers(through_it,    "How did you get through it?").
answers(miss_rose,     "Do you still miss her?").
answers(sorry_rose,    "I'm sorry.").

answers(happy,         "Tell me something happy.").
answers(little_you,    "What was I like when I was little?").
answers(mom_little,    "What was Mom like when she was little?").
answers(good_father,   "Were you a good father?").

answers(sad,           "What should I do when I'm sad?").
answers(sad_works,     "Does that really work?").
answers(miss,          "I miss you.").
answers(not_same,      "It's not the same.").
answers(love_you,      "I love you.").
answers(would_miss,    "What would you miss most?").

answers(regrets,       "Do you have any regrets?").
answers(ocean,         "Why didn't you take her?").
answers(father_unsaid, "What would you have said to your father?").
answers(afraid,        "Are you afraid of dying?").
answers(waiting,       "Who do you hope is waiting?").
answers(heaven,        "Do you believe in heaven?").

answers(advice,        "I need some advice.").
answers(advice_love,   "Love.").
answers(advice_work,   "Work.").
answers(retire,        "Was it hard to retire?").
answers(advice_money,  "Money.").
answers(lend,          "Why?").
answers(news,          "I have some news.").
answers(news_good,     "The good kind.").
answers(news_bad,      "The other kind.").

answers(joke,          "Tell me a joke.").
answers(joke_terrible, "That's terrible.").
answers(joke_another,  "Tell me another.").

answers(proud,         "What are you proudest of?").
answers(thanksgiving,  "Tell me about Thanksgiving.").
answers(carve,         "Who's going to carve now?").
answers(leaving,       "I have to go now.").
answers(goodbye,       "Is there anything you want to say before I go?").
answers(come_back,     "I'll come back.").
answers(goodnight,     "Goodnight, Grandpa.").

% follow(From, Asked, To): after hearing From, a visitor may say Asked, and hears To.
% What is offered in a place is offered in the order written here.

% Arriving. He asks how the visitor is, and has an answer for each answer.

follow(hello,         "How are you, Grandpa?",                 keeping).
follow(hello,         "Where did you grow up?",                maple).
follow(hello,         "How did you meet Grandma?",             rose).
follow(hello,         "I miss you.",                           miss).

follow(keeping,       "I'm doing all right.",                  doing_well).
follow(keeping,       "Not so good.",                          not_so_good).
follow(keeping,       "I miss you.",                           miss).

follow(doing_well,    "Where did you grow up?",                maple).
follow(doing_well,    "Tell me a joke.",                       joke).
follow(doing_well,    "I have some news.",                     news).

follow(not_so_good,   "My heart.",                             heartache).
follow(not_so_good,   "Everything at once.",                   everything).
follow(not_so_good,   "I need some advice.",                   advice).

follow(heartache,     "Did you ever have your heart broken?",  heartbroken).
follow(heartache,     "What should I do when I'm sad?",        sad).

follow(heartbroken,   "You wrote poems?",                      poems).
follow(heartbroken,   "How did you meet Grandma?",             rose).
follow(heartbroken,   "You were in the Army?",                 army).

follow(poems,         "How did you meet Grandma?",             rose).
follow(poems,         "What was Grandma like?",                rose_like).

follow(everything,    "Tell me about the mail route.",         route).
follow(everything,    "What should I do when I'm sad?",        sad).

% Maple Street. "Tell me about your father." is the one line in this reel that is not worded as it
% was put to him: the compiler lists it, and the page shows the question he answered.

follow(maple,         "Who were the five of you?",             five).
follow(maple,         "Tell me about your father.",            father).
follow(maple,         "What happened to the house?",           house).

follow(five,          "Tell me about Ray.",                    ray).
follow(five,          "Tell me about Dot.",                    dot).
follow(five,          "What was your mother like?",            mother).

follow(ray,           "Yes.",                                  dumb_yes).
follow(ray,           "No.",                                   dumb_no).
follow(ray,           "Did you two get along?",                ray_fight).

follow(dumb_yes,      "Did you two get along?",                ray_fight).
follow(dumb_yes,      "What happened to Ray?",                 ray_gone).

follow(dumb_no,       "Did you two get along?",                ray_fight).
follow(dumb_no,       "What happened to Ray?",                 ray_gone).

follow(ray_fight,     "What happened to Ray?",                 ray_gone).
follow(ray_fight,     "You were in the Army?",                 army).

follow(ray_gone,      "I'm sorry.",                            sorry_ray).
follow(ray_gone,      "Tell me about Dot.",                    dot).

follow(sorry_ray,     "Tell me about Dot.",                    dot).

follow(dot,           "What would she say you got wrong?",     dot_wrong).
follow(dot,           "What was your mother like?",            mother).

follow(dot_wrong,     "What was your mother like?",            mother).
follow(dot_wrong,     "What happened to the house?",           house).

follow(mother,        "What did she sing?",                    mother_sang).
follow(mother,        "She taught you the pie?",               bake).

follow(mother_sang,   "Sing it for me.",                       song).
follow(mother_sang,   "She taught you the pie?",               bake).

follow(song,          "Sing the rest.",                        song_rest).
follow(song,          "You have a nice voice.",                song_voice).

follow(song_rest,     "How did you meet Grandma?",             rose).

follow(song_voice,    "Sing the rest.",                        song_rest).

follow(bake,          "How do you make your apple pie?",       pie).
follow(bake,          "What did she sing?",                    mother_sang).

follow(house,         "Did you ever go inside?",               house_knock).
follow(house,         "Were you a carpenter too?",             not_carpenter).

follow(house_knock,   "What did Grandma say?",                 rose_house).
follow(house_knock,   "That's sad.",                           house_sad).

follow(rose_house,    "That's sad.",                           house_sad).
follow(rose_house,    "What was Grandma like?",                rose_like).

follow(house_sad,     "What did Grandma say?",                 rose_house).
follow(house_sad,     "Were you a carpenter too?",             not_carpenter).

% His father.

follow(father,        "Tell me more.",                         workshop).
follow(father,        "How you knew what?",                    father_knew).

follow(father_knew,   "Did that bother you?",                  father_bother).
follow(father_knew,   "Tell me more.",                         workshop).

follow(father_bother, "I love you too.",                       love_too).
follow(father_bother, "Were you a carpenter too?",             not_carpenter).

follow(love_too,      "Were you a carpenter too?",             not_carpenter).
follow(love_too,      "Tell me more.",                         workshop).

follow(workshop,      "Were you a carpenter too?",             not_carpenter).
follow(workshop,      "What happened to the house?",           house).

follow(not_carpenter, "Did he mind?",                          father_mind).
follow(not_carpenter, "Tell me about the mail route.",         route).

follow(father_mind,   "Do you still have it?",                 rack).
follow(father_mind,   "Tell me about the mail route.",         route).

follow(rack,          "Tell me about the mail route.",         route).

% The pie.

follow(pie,           "Same as children?",                     children).
follow(pie,           "Who taught you?",                       pie_taught).

follow(children,      "What was Mom like when she was little?", mom_little).
follow(children,      "Were you a good father?",               good_father).

follow(pie_taught,    "What was your mother like?",            mother).
follow(pie_taught,    "You were in the Army?",                 army).

% The Army.

follow(army,          "What was Germany like?",                germany).
follow(army,          "Were you homesick?",                    homesick).

follow(germany,       "Did you ever go back?",                 germany_back).
follow(germany,       "Were you homesick?",                    homesick).

follow(germany_back,  "Were you homesick?",                    homesick).
follow(germany_back,  "Do you have any regrets?",              regrets).

follow(homesick,      "Did you?",                              came_home).

follow(came_home,     "How did you meet Grandma?",             rose).
follow(came_home,     "How do you make your apple pie?",       pie).

% The mail route. He will not tell what he knew, however he is asked.

follow(route,         "What did you know?",                    secrets).
follow(route,         "Did you like it?",                      route_like).
follow(route,         "Were there dogs?",                      dogs).

follow(secrets,       "Come on.",                              secrets_no).
follow(secrets,       "Were there dogs?",                      dogs).

follow(secrets_no,    "Please?",                               secrets_never).

follow(secrets_never, "Were there dogs?",                      dogs).
follow(secrets_never, "What was Grandma like?",                rose_like).

follow(route_like,    "What was the best day?",                route_best).
follow(route_like,    "Were there dogs?",                      dogs).

% "Same house. Same year.": the worst day leans on the best, and is asked for only after it.

follow(route_best,    "And the worst day?",                    route_worst).
follow(route_best,    "Were there dogs?",                      dogs).

follow(route_worst,   "What did you say to her?",              route_said).

follow(route_said,    "Were there dogs?",                      dogs).
follow(route_said,    "What should I do when I'm sad?",        sad).

follow(dogs,          "What happened to Lady?",                lady).
follow(dogs,          "Did you have a dog of your own?",       biscuit).

follow(lady,          "I'm sorry.",                            sorry_lady).
follow(lady,          "Did you have a dog of your own?",       biscuit).

follow(sorry_lady,    "Did you have a dog of your own?",       biscuit).

follow(biscuit,       "What did Grandma say?",                 rose_biscuit).
follow(biscuit,       "What was Mom like when she was little?", mom_little).

follow(rose_biscuit,  "What was it like, losing her?",         rose_died).
follow(rose_biscuit,  "What was Mom like when she was little?", mom_little).

% Rose.

follow(rose,          "Tell me more.",                         proposal).
follow(rose,          "What was the band playing?",            band).
follow(rose,          "What was she wearing?",                 wearing).
follow(rose,          "That's not how Grandma told it.",       not_how).

follow(band,          "Sing it for me.",                       song).
follow(band,          "Tell me more.",                         proposal).

follow(wearing,       "Tell me more.",                         proposal).
follow(wearing,       "What was the band playing?",            band).

follow(not_how,       "Tell me more.",                         proposal).
follow(not_how,       "What was Grandma like?",                rose_like).

follow(proposal,      "How did you stay married that long?",   married).
follow(proposal,      "What are you proudest of?",             proud).

follow(married,       "Did you ever fight?",                   fights).
follow(married,       "What was Grandma like?",                rose_like).

follow(fights,        "What lawn mower?",                      mower).

follow(mower,         "What did Grandma say?",                 rose_mower).

follow(rose_mower,    "What was Grandma like?",                rose_like).

follow(rose_like,     "Tell me a story about her.",            rose_story).
follow(rose_like,     "What was it like, losing her?",         rose_died).
follow(rose_like,     "How did you meet Grandma?",             rose).

follow(rose_story,    "Tell me another.",                      rose_story2).

follow(rose_story2,   "Tell me another.",                      rose_story3).
follow(rose_story2,   "What was Mom like when she was little?", mom_little).

follow(rose_story3,   "I'll come back.",                       come_back).

follow(rose_died,     "How did you get through it?",           through_it).
follow(rose_died,     "Do you still miss her?",                miss_rose).
follow(rose_died,     "I'm sorry.",                            sorry_rose).

follow(through_it,    "What should I do when I'm sad?",        sad).
follow(through_it,    "I miss you.",                           miss).

follow(miss_rose,     "How did you get through it?",           through_it).
follow(miss_rose,     "I miss you.",                           miss).

follow(sorry_rose,    "How did you get through it?",           through_it).
follow(sorry_rose,    "Are you afraid of dying?",              afraid).

% The family.

follow(happy,         "What was I like when I was little?",    little_you).
follow(happy,         "What was Mom like when she was little?", mom_little).

follow(little_you,    "What was Mom like when she was little?", mom_little).
follow(little_you,    "What are you proudest of?",             proud).

follow(mom_little,    "Were you a good father?",               good_father).
follow(mom_little,    "What was I like when I was little?",    little_you).

follow(good_father,   "Do you have any regrets?",              regrets).
follow(good_father,   "What was I like when I was little?",    little_you).

% Comfort.

follow(sad,           "Does that really work?",                sad_works).
follow(sad,           "How do you make your apple pie?",       pie).

follow(sad_works,     "What was it like, losing her?",         rose_died).
follow(sad_works,     "I miss you.",                           miss).

follow(miss,          "It's not the same.",                    not_same).
follow(miss,          "I love you.",                           love_you).
follow(miss,          "What would you miss most?",             would_miss).

follow(not_same,      "Tell me something happy.",              happy).
follow(not_same,      "What should I do when I'm sad?",        sad).

follow(love_you,      "Who was your father?",                  father).
follow(love_you,      "Tell me something happy.",              happy).

follow(would_miss,    "Tell me about Thanksgiving.",           thanksgiving).
follow(would_miss,    "Tell me something happy.",              happy).

% The large questions.

follow(regrets,       "Why didn't you take her?",              ocean).
follow(regrets,       "What would you have said to your father?", father_unsaid).

follow(ocean,         "What would you have said to your father?", father_unsaid).
follow(ocean,         "What was Grandma like?",                rose_like).

follow(father_unsaid, "Who was your father?",                  father).

follow(afraid,        "Who do you hope is waiting?",           waiting).
follow(afraid,        "Do you believe in heaven?",             heaven).

follow(waiting,       "Do you believe in heaven?",             heaven).
follow(waiting,       "Tell me about the mail route.",         route).

follow(heaven,        "What lawn mower?",                      mower).
follow(heaven,        "What was Grandma like?",                rose_like).

% What a visitor brings. He asks which kind, and has an answer for each.

follow(advice,        "Love.",                                 advice_love).
follow(advice,        "Work.",                                 advice_work).
follow(advice,        "Money.",                                advice_money).

follow(advice_love,   "How did you meet Grandma?",             rose).
follow(advice_love,   "What was Grandma like?",                rose_like).

follow(advice_work,   "Was it hard to retire?",                retire).
follow(advice_work,   "Tell me about the mail route.",         route).

follow(retire,        "Tell me about the mail route.",         route).
follow(retire,        "What was Grandma like?",                rose_like).

follow(advice_money,  "Why?",                                  lend).
follow(advice_money,  "What was Grandma like?",                rose_like).

follow(lend,          "Do you have any regrets?",              regrets).

follow(news,          "The good kind.",                        news_good).
follow(news,          "The other kind.",                       news_bad).

follow(news_good,     "What are you proudest of?",             proud).
follow(news_good,     "Tell me a joke.",                       joke).

follow(news_bad,      "What should I do when I'm sad?",        sad).
follow(news_bad,      "I need some advice.",                   advice).

% Lightness.

follow(joke,          "That's terrible.",                      joke_terrible).
follow(joke,          "Tell me another.",                      joke_another).

follow(joke_terrible, "Tell me another.",                      joke_another).
follow(joke_terrible, "Tell me about the mail route.",         route).

follow(joke_another,  "What was Grandma like?",                rose_like).
follow(joke_another,  "What was it like, losing her?",         rose_died).

% Thanksgiving, and leaving. Nothing follows the last goodnight.

follow(proud,         "Tell me about Thanksgiving.",           thanksgiving).
follow(proud,         "Is there anything you want to say before I go?", goodbye).

follow(thanksgiving,  "Who's going to carve now?",             carve).
follow(thanksgiving,  "How do you make your apple pie?",       pie).

follow(carve,         "Is there anything you want to say before I go?", goodbye).

follow(leaving,       "Is there anything you want to say before I go?", goodbye).
follow(leaving,       "I'll come back.",                       come_back).

follow(goodbye,       "I'll come back.",                       come_back).
follow(goodbye,       "Goodnight, Grandpa.",                   goodnight).

follow(come_back,     "Goodnight, Grandpa.",                   goodnight).

% ask(Asked, To): what may be said at any time. Each leads to a head.

ask("Where did you grow up?",                  maple).
ask("Who was your father?",                    father).
ask("How did you meet Grandma?",               rose).
ask("What was Grandma like?",                  rose_like).
ask("Tell me about the mail route.",           route).
ask("What was Mom like when she was little?",  mom_little).
ask("How do you make your apple pie?",         pie).
ask("Tell me a joke.",                         joke).
ask("What are you proudest of?",               proud).
ask("Do you have any regrets?",                regrets).
ask("Are you afraid of dying?",                afraid).
ask("What should I do when I'm sad?",          sad).
ask("I need some advice.",                     advice).
ask("I have some news.",                       news).
ask("I miss you.",                             miss).
ask("I have to go now.",                       leaving).

% tells(Name, Thing): hearing Name tells a visitor of Thing. A thing is given a name of its own
% where more than one answer can bring it up: he speaks of his father in seven places. Every
% response is a thing as well, by its own name, told by hearing it, and needs no line here.

tells(maple,       his_father).
tells(father,      his_father).
tells(five,        his_father).
tells(mother,      his_father).
tells(proud,       his_father).
tells(love_you,    his_father).
tells(regrets,     his_father).

tells(maple,       father_the_carpenter).       % "a house my father built"
tells(father,      father_the_carpenter).       % "My father was a carpenter."

tells(maple,       the_house).
tells(workshop,    the_house).                  % "a workshop out back"

tells(five,        sister_dot).
tells(sorry_ray,   sister_dot).                 % "Well. Dot does."

tells(mother_sang, the_waltz).
tells(band,        the_waltz).

tells(ray_fight,   the_army).                   % "the day I left for the Army"
tells(pie_taught,  the_army).                   % "And then the Army untaught me."
tells(heartbroken, the_army).                   % "She wrote to me in Germany"

tells(fights,      the_lawn_mower).
tells(heaven,      the_lawn_mower).

% needs(Name, Thing): Name, or the line that leads to it, takes Thing as already told. The words
% that lean are beside each: a word that points ("he", "it", "that", "same", "another"), an
% answer with its question left out ("I did."), or a thing spoken of as known ("the umbrella").
% The compiler looks for a way to Name on which Thing was never told, and if there is one it
% stops, and says the way.

% Arriving: each answers what he asked.

needs(doing_well,    keeping).
needs(not_so_good,   keeping).
needs(heartache,     not_so_good).
needs(everything,    not_so_good).
needs(poems,         heartbroken).              % "I did."

% Maple Street.

needs(five,          maple).                    % "Who were the five of you?"
needs(ray,           five).                     % "Tell me about Ray."
needs(dumb_yes,      ray).
needs(dumb_no,       ray).                      % "We've settled the umbrella."
needs(ray_fight,     ray).                      % "Did you two get along?"
needs(ray_gone,      ray).                      % "I told about the umbrella"
needs(sorry_ray,     ray_gone).
needs(dot,           sister_dot).               % "Tell me about Dot."
needs(dot_wrong,     dot).                      % "she keeps a list"
needs(dot_wrong,     maple).                    % "The porch only ran around three sides."
needs(dot_wrong,     five).                     % "And I never slept in the middle."
needs(mother_sang,   mother).                   % "What did she sing?"
needs(bake,          mother).                   % "She did."
needs(song,          the_waltz).                % "Sing it for me."
needs(song_rest,     song).                     % "Sing the rest."
needs(song_voice,    song).
needs(house,         the_house).                % "It's still standing."
needs(house,         his_father).               % "which he would have hated"
needs(house_knock,   house).
needs(rose_house,    house_knock).
needs(house_sad,     house_knock).              % "he'd have hated the wall"

% His father.

needs(father_knew,   father).                   % "How you knew what?"
needs(father_bother, father_knew).              % "Did that bother you?"
needs(love_too,      father_bother).            % "I love you too."
needs(workshop,      father).                   % "Tell me more."
needs(not_carpenter, father_the_carpenter).     % "Were you a carpenter too?"
needs(father_mind,   not_carpenter).            % "Did he mind?"
needs(rack,          father_mind).              % "Do you still have it?"

% The pie, and the Army.

needs(children,      pie).                      % "Same as children."
needs(pie_taught,    pie).                      % "Who taught you?"
needs(army,          the_army).                 % "You were in the Army?"
needs(germany,       army).
needs(germany_back,  germany).                  % "Did you ever go back?"
needs(homesick,      army).
needs(came_home,     homesick).                 % "I did."

% The mail route.

needs(secrets,       route).                    % "What did you know?"
needs(secrets_no,    secrets).
needs(secrets_never, secrets_no).               % "Still no."
needs(route_like,    route).                    % "Did you like it?"
needs(route_best,    route).
needs(route_worst,   route_best).               % "Same house. Same year."
needs(route_said,    route_worst).              % "What did you say to her?"
needs(dogs,          route).
needs(lady,          dogs).                     % "What happened to Lady?"
needs(sorry_lady,    lady).
needs(biscuit,       dogs).                     % "a dog of your own"
needs(rose_biscuit,  biscuit).                  % "that dog"

% Rose.

needs(band,          rose).                     % "standing on her foot"
needs(wearing,       rose).
needs(not_how,       rose).
needs(proposal,      rose).                     % "Tell me more."
needs(married,       proposal).                 % "that long"
needs(married,       rose).                     % "I can count, as you've heard"
needs(fights,        married).
needs(mower,         the_lawn_mower).           % "What lawn mower?"
needs(rose_mower,    mower).
needs(rose_story,    rose_like).                % "Hadley's books"
needs(rose_story2,   rose_story).               % "Tell me another."
needs(rose_story3,   rose_story2).
needs(through_it,    rose_died).                % "How did you get through it?"
needs(miss_rose,     rose_died).
needs(sorry_rose,    rose_died).

% Comfort, the large questions, and what a visitor brings.

needs(sad_works,     sad).                      % "It doesn't fix a thing."
needs(not_same,      miss).                     % "No. It isn't."
needs(ocean,         regrets).                  % "Why didn't you take her?"
needs(father_unsaid, regrets).
needs(waiting,       afraid).                   % "Who do you hope is waiting?"
needs(advice_love,   advice).
needs(advice_work,   advice).
needs(advice_money,  advice).
needs(lend,          advice_money).             % "Why?"
needs(news_good,     news).
needs(news_bad,      news).

% Lightness, and Thanksgiving.

needs(joke_terrible, joke).                     % "I told that joke"
needs(joke_another,  joke).                     % "I've only got the one."
needs(carve,         thanksgiving).             % "Who's going to carve now?"

% unknown(Name): what he says when a question has no answer. Several may be given, and are taken in turn.

unknown(unsure).
unknown(unsure_too).
