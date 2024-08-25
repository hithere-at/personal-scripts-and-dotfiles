#!/bin/env python3

from datetime import datetime
from time import sleep
from random import choice as random_choice
from sys import argv

def greet(greet_type):

    time = datetime.now()
    hour = int(time.strftime("%H"))

    morning_greeting = ["Remember to have breakfast!",
                        "How is the weather?",
                        "Enjoy your day!"]

    afternoon_greeting = ["I'ts time for lunch!",
                          "So sleepy...",
                          "Have you done your homework?"]

    evening_greeting = ["A dinner would be great..",
                        "Maybe you should start getting ready for tomorrow..",
                        "Enjoy the night!"]

    night_greeting = ["It's time to take a rest..",
                      "*yawn*...",
                      "Do you plan to stay up late?"]

    midnight_greeting = ["Staying up late is unhealthy. Please rest..",
                         "Just one more...",
                         "You should rest"]

    if hour >= 22:
        if greet_type == "login":
            print(f"Good night, {argv[1]}")

        else:
            print(random_choice(night_greeting))

    elif hour >= 18:
        if greet_type == "login":
            print(f"Good evening, {argv[1]}")

        else:
            print(random_choice(evening_greeting))

    elif hour >= 12:
        if greet_type == "login":
            print(f"Good afternoon, {argv[1]}")

        else:
            print(random_choice(afternoon_greeting))

    elif hour >= 5:
        if greet_type == "login":
            print(f"Good morning, {argv[1]}")

        else:
            print(random_choice(morning_greeting))

    elif hour >= 0:
        if greet_type == "login":
            print("It's midnight, please rest..")

        else:
            print(random_choice(midnight_greeting))

greet("login")

while True:
    sleep(60)
    greet("infinite")
