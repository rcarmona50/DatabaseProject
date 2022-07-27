# Group 89: Jellyfisgh
# Name: Rafael Carmona and John Jenson
# Description: CS340 - Final Project - Code Name: Jellyfish
# Date: 6/6/2022

# Code Citation:
# Adapted from CS340 Flask Starter App
# Date: 6/1/2022
# source: https://github.com/osu-cs340-ecampus/flask-starter-app

from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
from datetime import datetime
import os

# Configuration
app = Flask(__name__)

#database connection info
app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
app.config["MYSQL_USER"] = "cs340_carmonar"
app.config["MYSQL_PASSWORD"] = "8177"
app.config["MYSQL_DB"] = "cs340_carmonar"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

# Routes 
@app.route("/")
def home():
    return redirect("/index")


@app.route("/index")
def index():
    return render_template("index.j2")


# routes for skills  
@app.route("/skills", methods=["POST", "GET"])
def skills():
    if request.method == "POST":
        if request.form.get("Add_skill"):
            # for add skill
            # get info from form
            name = request.form["name"]
            definition = request.form["definition"]
            pass_condition = request.form["pass_condition"]
            clients_client_id = request.form["client"]

            # sql to insert new skill
            query = "INSERT INTO skills (name, definition, pass_condition, clients_client_id) VALUES (%s, %s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (name, definition, pass_condition, clients_client_id))
            mysql.connection.commit()

        # redirect back to skills page
        return redirect("/skills")

    if request.method == "GET":
        # retrieve info to render page dynamically
        query = "SELECT skills_id, name, definition, pass_condition, clients_client_id FROM skills"
        cursor = mysql.connection.cursor()
        cursor.execute(query)
        data = cursor.fetchall()

        # mySQL query
        query2 = "SELECT client_id, fname, lname FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        client_data = cur.fetchall()

        return render_template("skills.j2", data=data, client_data=client_data)


@app.route("/delete_skill/<int:skills_id>")
def delete_skill(skills_id):
    # mySQL query to delete the skill
    query = "DELETE FROM skills WHERE skills_id = '%s'"
    cur = mysql.connection.cursor()
    cur.execute(query, (skills_id,))
    mysql.connection.commit()

    # redirect back to skills page
    return redirect("/skills")


@app.route("/edit_skill/<int:skills_id>", methods=["POST", "GET"])
def edit_skill(skills_id):
    if request.method == "GET":
        # mySQL query to grab the info of the behavior with our passed id
        query = "SELECT * FROM skills WHERE skills_id = %s" % (skills_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query
        query2 = "SELECT skills_id, name FROM skills"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        skill_data = cur.fetchall()

        # render edit_behavior page passing our query data and behavior data to the edit_behavior template
        return render_template("edit_skill.j2", data=data, skills=skill_data)

    if request.method == "POST":
        # fire off if user clicks the 'Edit behavior' button
        if request.form.get("Edit_skill"):
            # grab user form inputs
            id = request.form["skillID"]
            name = request.form["name"]
            definition = request.form["definition"]
            pass_condition = request.form["pass_condition"]
            client_id = request.form["clients_client_id"]

            query = "UPDATE problem_behaviors SET skills.id = %s, skills.name = %s, skills.definition = %s, skills.pass_condition = %s WHERE skills.clients_client_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (id, name, definition, pass_condition, client_id))
            mysql.connection.commit()

            # redirect back to behavior page after we execute the update query
            return redirect("/skills")


# needs to be rendered from info from appointments page, this is the single appointment and relevant data entry for
# behavior occurrences and skill trials
@app.route("/client_sessions/<int:appointment_id>", methods=["POST", "GET"])
def client_sessions(appointment_id):
    if request.method == "POST":

        if request.form.get("add_skill"):
            # for add skill trial
            # get info from form
            id = request.form["name"]
            prompt = request.form["prompt"]
            passed = request.form["passed"]

            # sql to insert new skill
            query = "INSERT INTO skill_trials (prompt, passed, appointments_appointment_id, skills_skills_id) VALUES (%s, %s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (prompt, passed, appointment_id, id))
            mysql.connection.commit()

        if request.form.get("add_behavior"):
            # for add behavior event
            # get info from form
            id = request.form["behavior_name"]
            time = request.form["time"]
            end_time = request.form["end"]
            occurrences = request.form["occurrences"]

            # sql to insert new behavior
            query = "INSERT INTO behaviors (time, end_time, ocurrences, appointments_appointment_id, problem_behaviors_behavior_id) VALUES (%s, %s, %s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (time, end_time, occurrences, appointment_id, id))
            mysql.connection.commit()

        # redirect back to sessions page
        return redirect("/client_sessions/%s" % (appointment_id))

    if request.method == "GET":
        # retrieve info to render page dynamically
        # get appt data
        query1 = "SELECT appointment_id, date, time, end_time, providers_provider_id, clients_client_id FROM appointments where appointment_id =%s" % (appointment_id)
        cur = mysql.connection.cursor()
        cur.execute(query1)
        appointment_data = cur.fetchall()

        query2 = "SELECT skill_trial_id, prompt, passed, appointments_appointment_id, skills_skills_id FROM skill_trials where appointments_appointment_id =%s" % (appointment_id)
        cur = mysql.connection.cursor()
        cur.execute(query2)
        skill_trial_data = cur.fetchall()

        query3 = "SELECT behavior_event_id, time, end_time, ocurrences, appointments_appointment_id, problem_behaviors_behavior_id FROM behaviors WHERE appointments_appointment_id =%s" % (appointment_id)
        cur = mysql.connection.cursor()
        cur.execute(query3)
        behavior_data = cur.fetchall()

        # get client info for the other tables
        query4 = "SELECT client_id, fname, lname, insurance_num FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query4)
        client_data = cur.fetchall()

        # get behavior and skill data relevant to the client for create option
        query5 = "SELECT behavior_id, name, definition, clients_client_id FROM problem_behaviors"
        cur = mysql.connection.cursor()
        cur.execute(query5)
        problem_behavior_data = cur.fetchall()

        query6 = "SELECT skills_id, name, definition, pass_condition, clients_client_id FROM skills"
        cur = mysql.connection.cursor()
        cur.execute(query6)
        skill_data = cur.fetchall()

        return render_template("client_sessions.j2", appointment_data=appointment_data, skill_trial_data=skill_trial_data, behavior_data=behavior_data, client_data=client_data, problem_behavior_data=problem_behavior_data, skill_data=skill_data)


@app.route("/delete_skill_trial/<int:appointment_id>/<int:skill_trial_id>")
def delete_skill_trial(appointment_id, skill_trial_id):
    # mySQL query to delete the behavior
    query = "DELETE FROM skill_trials WHERE skill_trial_id = '%s'"
    cur = mysql.connection.cursor()
    cur.execute(query, (skill_trial_id,))
    mysql.connection.commit()

    # redirect back to behaviors page
    return redirect("/client_sessions/%s" % (appointment_id))


@app.route("/delete_behavior_event/<int:appointment_id>/<int:behavior_event_id>")
def delete_behavior_event(appointment_id, behavior_event_id):
    # mySQL query to delete the behavior
    query = "DELETE FROM behaviors WHERE behavior_event_id = '%s'"
    cur = mysql.connection.cursor()
    cur.execute(query, (behavior_event_id,))
    mysql.connection.commit()

    # redirect back to behaviors page
    return redirect("/client_sessions/%s" % (appointment_id))


# routes for behaviors
@app.route("/behaviors", methods=["POST", "GET"])
def behaviors():
    if request.method == "POST":
        if request.form.get("Add_behavior"):
            # for add behavior
            # get info from form
            name = request.form["name"]
            definition = request.form["definition"]
            clients_client_id = request.form["client"]

            # sql to insert new behavior
            query = "INSERT INTO problem_behaviors (name, definition, clients_client_id) VALUES (%s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (name, definition, clients_client_id))
            mysql.connection.commit()

        # redirect back to behaviors page
        return redirect("/behaviors")

    if request.method == "GET":
        # retrieve info to render page dynamically
        query = "SELECT behavior_id, name, definition, clients_client_id FROM problem_behaviors"
        cursor = mysql.connection.cursor()
        cursor.execute(query)
        data = cursor.fetchall()

        # mySQL query
        query2 = "SELECT client_id, fname, lname FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        client_data = cur.fetchall()

        return render_template("behaviors.j2", data=data, client_data=client_data)


@app.route("/delete_behavior/<int:behavior_id>")
def delete_behavior(behavior_id):
    # mySQL query to delete the behavior
    query = "DELETE FROM problem_behaviors WHERE behavior_id = '%s'"
    cur = mysql.connection.cursor()
    cur.execute(query, (behavior_id,))
    mysql.connection.commit()

    # redirect back to behaviors page
    return redirect("/behaviors")


@app.route("/edit_behavior/<int:behavior_id>", methods=["POST", "GET"])
def edit_behavior(behavior_id):
    if request.method == "GET":
        # mySQL query to grab the info of the behavior with our passed id
        query = "SELECT * FROM problem_behaviors WHERE behavior_id = %s" % (behavior_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query
        query2 = "SELECT behavior_id, name FROM problem_behaviors"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        behavior_data = cur.fetchall()

        # render edit_behavior page passing our query data and behavior data to the edit_behavior template
        return render_template("edit_behavior.j2", data=data, behavior_data=behavior_data)


    if request.method == "POST":
        # fire off if user clicks the 'Edit behavior' button
        if request.form.get("Edit_behavior"):
            # grab user form inputs
            id = request.form["behaviorID"]
            name = request.form["name"]
            definition = request.form["definition"]
            client_id = request.form["clients_client_id"]

            query = "UPDATE problem_behaviors SET problem_behaviors.id = %s, problem_behaviors.name = %s, problem_behaviors.definition = %s WHERE problem_behaviors.clients_client_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (id, name, definition, client_id))
            mysql.connection.commit()

            # redirect back to behavior page after we execute the update query
            return redirect("/behaviors")


@app.route("/provider", methods=["POST", "GET"])
def provider():
    # Separate out the request methods, in this case this is for a POST
    # insert a provider into the provider entity
    if request.method == "POST":
        # fire off if user presses the Add provider button
        if request.form.get("Add_provider"):
            # grab user form inputs
            fname = request.form["fname"]
            lname = request.form["lname"]
            credentials = request.form["credentials"]
            
            if credentials == "":
                #mySQL query to insert a new provider into bsg_provider with our form inputs
                query = "INSERT INTO providers (fname, lname) VALUES (%s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (fname, lname))
                mysql.connection.commit()

            else:
                query = "INSERT INTO providers (fname, lname, credentials) VALUES (%s, %s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (fname, lname, credentials))
                mysql.connection.commit()

            # redirect back to provider page
            return redirect("/provider")

    # Grab provider data so we send it to our template to display
    if request.method == "GET":
        # mySQL query to grab all the provider in bsg_provider
        query = "SELECT provider_id, fname, lname, credentials FROM providers"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # render edit_provider page passing our query data and homeworld data to the edit_provider template
        return render_template("provider.j2", data=data)


# route for delete functionality, deleting a provider from provider,
@app.route("/delete_provider/<int:provider_id>")
def delete_provider(provider_id):
    # mySQL query to delete the provider with our passed id
    query = "DELETE FROM providers WHERE provider_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (provider_id,))
    mysql.connection.commit()

    # redirect back to provider page
    return redirect("/provider")

@app.route("/edit_provider/<int:provider_id>", methods=["POST", "GET"])
def edit_provider(provider_id):
    if request.method == "GET":
        # mySQL query to grab the info of the provider with our passed id
        query = "SELECT * FROM providers WHERE provider_id = %s" % (provider_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query 
        query2 = "SELECT provider_id, fname FROM providers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        provider_data = cur.fetchall()

        # render edit_provider page passing our query data and homeworld data to the edit_provider template
        return render_template("edit_provider.j2", data=data, providers=provider_data)

    if request.method == "POST":
        # fire off if user clicks the 'Edit provider' button
        if request.form.get("Edit_provider"):
            # grab user form inputs
            id = request.form["providerID"]
            fname = request.form["fname"]
            lname = request.form["lname"]
            credentials = request.form["credentials"]

            query = "UPDATE providers SET providers.fname = %s, providers.lname = %s, providers.credentials = %s WHERE providers.provider_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (fname, lname, credentials, provider_id))
            mysql.connection.commit()

            # redirect back to provider page after we execute the update query
            return redirect("/provider")


@app.route("/appointments", methods=["POST", "GET"])
def appointments():
    if request.method == "POST":
        # fire off if user presses the Add provider button
        if request.form.get("Add_appointment"):
            # grab user form inputs
            clients_client_id = request.form["clientDD"]
            the_date = request.form["the_date"]
            time = request.form["time"]
            end_time = request.form["end_time"]
            providers_provider_id = request.form["providerDD"]

            # account for null - If no Provider provided yet
            if providers_provider_id == "0":
                # mySQL query to insert a new person into bsg_people with our form inputs
                query = "INSERT INTO appointments (clients_client_id, date,time,end_time) VALUES (%s, %s, %s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (clients_client_id, the_date,time,end_time))
                mysql.connection.commit()
            
            else:
                query = "INSERT INTO appointments (clients_client_id, date,time,end_time, providers_provider_id) VALUES (%s, %s, %s, %s ,%s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (clients_client_id, the_date,time,end_time, providers_provider_id))
                mysql.connection.commit()

        if request.form.get("search"):
            id = request.form["searched"]
            query = "SELECT appointments.appointment_id, clients.client_id, CONCAT(clients.fname, ' ', clients.lname) AS Client, appointments.date, appointments.time, appointments.end_time, CONCAT(providers.fname, ' ', providers.lname) AS Provider FROM appointments JOIN providers ON appointments.providers_provider_id = providers.provider_id JOIN clients ON appointments.clients_client_id = clients.client_id WHERE appointments.clients_client_id = %s" % (id)
            cur = mysql.connection.cursor()
            cur.execute(query)
            res = cur.fetchall()
            
            return render_template("/appointments.j2", results=res)

            # redirect back to provider page
        return redirect("/appointments")


    if request.method == "GET":
        # mySQL query to grab the info of the client with our passed id
        query = "SELECT appointments.appointment_id, clients.client_id, CONCAT(clients.fname, ' ' ,clients.lname) AS Client, appointments.date AS Date, appointments.time AS Time, appointments.end_time AS End_Time, CONCAT(providers.fname, ' ' ,providers.lname) AS Provider from appointments LEFT JOIN providers ON appointments.providers_provider_id = providers.provider_id LEFT JOIN clients ON appointments.clients_client_id = clients.client_id"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        query2 = "SELECT client_id, fname, lname FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        clientDD_data = cur.fetchall()

        query3 = "SELECT provider_id, fname, lname FROM providers"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        providerDD_data = cur.fetchall()

        # render edit_client page passing our query data and homeworld data to the edit_client template
        return render_template("appointments.j2", data=data, clientDDs=clientDD_data, providerDDs=providerDD_data)


@app.route("/delete_appointment/<int:appointment_id>")
def delete_apointment(appointment_id):
    # mySQL query to delete the provider with our passed id
    query = "DELETE FROM appointments WHERE appointment_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (appointment_id,))
    mysql.connection.commit()

    # redirect back to provider page
    return redirect("/appointments")   


@app.route("/update_appointment/<int:appointment_id>", methods=["POST", "GET"])
def update_appointment(appointment_id):
    if request.method == "GET":
        # mySQL query to grab the info of the provider with our passed id
        query = "SELECT appointment_id, clients.client_id, CONCAT(clients.fname, ' ', clients.lname) AS Client, appointments.date, appointments.time, appointments.end_time, CONCAT(providers.fname, ' ', providers.lname) AS Provider, providers.provider_id FROM appointments JOIN providers ON appointments.providers_provider_id = providers.provider_id JOIN clients ON appointments.clients_client_id = clients.client_id WHERE appointment_id = %s" % (appointment_id);
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query 
        query2 = "SELECT appointment_id, date, time, end_time FROM appointments"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        appointment_data = cur.fetchall()

        query2 = "SELECT client_id, fname, lname FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        clientDD_data = cur.fetchall()

        query3 = "SELECT provider_id, fname, lname FROM providers"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        providerDD_data = cur.fetchall()

        # render edit_provider page passing our query data and homeworld data to the edit_provider template
        return render_template("update_appointment.j2", data=data, appointment_data=appointment_data, clientDDs=clientDD_data, providerDDs=providerDD_data)

    if request.method == "POST":
        # fire off if user clicks the 'Edit provider' button
         if request.form.get("Update_Appointment"):
            # grab user form inputs
            id = request.form["updateAppointment"]
            date = request.form["date"]
            time = request.form["time"]
            end_time = request.form["end_time"]
            providers_provider_id = request.form["providerDD"]
            clients_client_id = request.form["clientDD"]

            query = "UPDATE appointments SET appointments.date = %s, appointments.time = %s, appointments.end_time = %s, appointments.providers_provider_id = %s, appointments.clients_client_id = %s WHERE appointments.appointment_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (date, time, end_time, providers_provider_id, clients_client_id, id))
            mysql.connection.commit()

            # redirect back to provider page after we execute the update query
            return redirect("/appointments")


# route for clients page
@app.route("/client", methods=["POST", "GET"])
def client():
    # Separate out the request methods, in this case this is for a POST
    # insert a client into the clients entity
    if request.method == "POST":
        # fire off if user presses the Add client button
        if request.form.get("Add_Client"):
            # grab user form inputs
            fname = request.form["fname"]
            lname = request.form["lname"]
            insurance_num = request.form["insurance_num"]
            
            if insurance_num == "":
                #mySQL query to insert a new client into bsg_clients with our form inputs
                query = "INSERT INTO clients (fname, lname) VALUES (%s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (fname, lname))
                mysql.connection.commit()

            else:
                query = "INSERT INTO clients (fname, lname, insurance_num) VALUES (%s, %s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (fname, lname, insurance_num))
                mysql.connection.commit()

            # redirect back to clients page
            return redirect("/client")

    # Grab client data so we send it to our template to display
    if request.method == "GET":
        # mySQL query to grab all the clients in bsg_clients
        query = "SELECT client_id, fname, lname, insurance_num FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # render edit_clients page passing our query data and homeworld data to the edit_clients template
        return render_template("client.j2", data=data)


# route for delete functionality, deleting a client from clients,
@app.route("/delete_client/<int:client_id>")
def delete_client(client_id):
    # mySQL query to delete the client with our passed id
    query = "DELETE FROM clients WHERE client_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (client_id,))
    mysql.connection.commit()

    # redirect back to client page
    return redirect("/client")


@app.route("/edit_client/<int:client_id>", methods=["POST", "GET"])
def edit_client(client_id):
    if request.method == "GET":
        # mySQL query to grab the info of the client with our passed id
        query = "SELECT * FROM clients WHERE client_id = %s" % (client_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query 
        query2 = "SELECT client_id, fname FROM clients"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        client_data = cur.fetchall()

        # render edit_client page passing our query data and homeworld data to the edit_client template
        return render_template("edit_client.j2", data=data, clients=client_data)


    if request.method == "POST":
        # fire off if user clicks the 'Edit Client' button
        if request.form.get("Edit_Client"):
            
            # grab user form inputs
            id = request.form["clientID"]
            fname = request.form["fname"]
            lname = request.form["lname"]
            insurance_num = request.form["insurance_num"]

            query = "UPDATE clients SET clients.fname = %s, clients.lname = %s, clients.insurance_num = %s WHERE clients.client_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (fname, lname,insurance_num, client_id))
            mysql.connection.commit()

            # redirect back to client page after we execute the update query
            return redirect("/client")


if __name__ == "__main__":
    app.run(port=9888, debug=True)
