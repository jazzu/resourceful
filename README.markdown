Resourceful
===========

Resourceful is a tool to solve for even task distribution between a bunch of tasks and workers automatically. It does this by taking a list of tasks requiring certain amount of workers over a certain time, and a list of available workers, and then goes through the two as follows:

1. Sort task longest tasks first (ie. tasks are ordered by required hours of attendance, eg. 5, 3, and 2 hours)
2. Look at the next task on the list and note its name
3. From the resource list, search for the worker who a) hasn't "worked last" on the task at hand and b) has worked the least amount of hours.
4. Update "worked last on" status of the worker, and add the hours of current task to his total hours worked
5. Add the found worker to a result table, under the current task
6. If the task requires more workers, go to 3, otherwise go to 2. Repeat until the whole task list is processed

Usage
-----

Instantiate class with your task and resource arrays, and tell it to do
scheduling. This results in an array that has tasks in their original order,
compared by task name. If there are not enough resources (ie. task requires
more workers than are available in the resource array), a
`NotEnoughResourcesError` will be raised with the task name, resouces required,
and resources available embedded.

Notice, that if you have identical task names, resulting task order may not be
identical to the original task list.

Example
-------

When not busy eavesdropping each other and encrypting messages, Alice, Bob, and
Eve are avid voluntary workers for a non-profit event organization. These
weekend-long events have a lot of things to do, and the event managers have
decided to automate their work schedule generation. For a certain Saturday they
have the following tasks to be done:

* Cleaning up the restrooms (budget ran out, no money to hire a company to do
  this)
* Distributing flyers for their next big event
* Take a bunch of customers for a prescheduled tour of the venue

These tasks require two, three, and one workers, correspondingly, and take an
hour, two hours, and three hours to complete.

Manager enters the data for the solver

    [{ :task_name => "Restroom cleaning", :hours => 1, :resources_required => 2 },
     { :task_name => "Flyer distribution", :hours => 2, :resources_required => 3 },
     { :task_name => "Tour of the venue", :hours => 3, :resources_required => 1 }]

    [{ :name => "Alice" }, { :name => "Bob" }, { :name => "Eve" }]

which gives out the following work schedule

    [{ :task_name => "Restroom cleaning", :resources_allocated => ["Bob", "Eve"] },
     { :task_name => "Flyer distribution", :resources_allocated => ["Alice", "Bob", "Eve"] },
     { :task_name => "Tour of the venue", :resources_allocated => ["Alice"] }]

Unfortunately, Alice ends up with five hours of work, while Bob and Eve have
only three hours to worry about. With longer task lists this will be less of an
issue, of course.
