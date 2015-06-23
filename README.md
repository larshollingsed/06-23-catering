# Catering Finance Manager

The catering finance manager helps keep track of employees' wages.

For example - I have 5 employees in my company.  In the last week my company has catered 8 events.  Each event has one employee as the manager and at least one other employee.  Given that each event has its own length of time, base hourly pay, and possibly a gratuity (to be split), I want to be able to write each employee their checks at the end of a week.  I also want to make sure that I didn't make any errors such as paying two people to manage one event.


## Description

### employees table
  * - id (primary key)
  * - name (text)
  * - age (integer)
  
### events table
  * - id (primary key)
  * - date (text?)
  * - length (number)
  * - hourly pay (number)
  * - gratuity (number)
  * - serving alcohol? (boolean)
  
### distributions table
  * - id (primary key)
  * - employee_id (foreign key)
  * - event_id (foreign key)
  * - manager? (boolean)


### What we should be able to do
  * - add/delete/modify an employee
  * - add/delete/modify a event
  * - attach one or many events to one or many employees
  * - calculate how much an employee earned (possibly over a given time period)
  * - calculate how many hours an employee worked (possibly over a given time       period)

### What we should not be able to do
  * - add an employee who is under 19 to an alcohol serving event
  * - have more than one manager attached to a event
  * - split tips with a manager