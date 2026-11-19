# Crontab Scheduling Exercises

**AWS re/Start — Batch 33**  
**Format:** Self-paced Linux lab

Write a user crontab entry for each of the 20 scenarios below. Use a practice logger so you can test scheduling without running real backups or maintenance. Check your work against the [solutions](SOLUTIONS.md) after each section.

## Set up the lab

Use a Linux machine with `crontab` installed and the cron service running. Run `date` to see the machine's local time. For this lab, assume cron uses that time zone.

```bash
mkdir -p "$HOME/cron-lab"
cat > "$HOME/cron-lab/log-run.sh" <<'SCRIPT'
#!/bin/sh
set -eu

log_dir="$HOME/cron-lab"
printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$1" >> "$log_dir/runs.log"
SCRIPT
chmod +x "$HOME/cron-lab/log-run.sh"
"$HOME/cron-lab/log-run.sh" setup
tail -n 5 "$HOME/cron-lab/runs.log"
```

## Read a cron schedule

```text
minute  hour  day-of-month  month  day-of-week  command
0–59    0–23  1–31          1–12   0–6 (Sun–Sat)
```

Use `*` for all values, `,` for a list, `-` for an inclusive range, and `/` for a step within a field. For example, `*/20` in the minute field matches minutes 0, 20, and 40 of each hour. When both day fields have explicit restrictions, common Linux cron implementations run the job when **either** day field matches.

End each entry with the command below, replacing `exNN` with the exercise number, such as `ex01`. The double quotes let the shell expand `$HOME` while keeping the script path together.

```text
"$HOME/cron-lab/log-run.sh" exNN
```

## Beginner · One schedule at a time

| # | Scenario |
|---|---|
| 01 | Run a heartbeat **every minute**. |
| 02 | Run a health check **every five minutes**, starting at minute 0 of each hour. |
| 03 | Collect a metric **every hour on the hour**. |
| 04 | Start a backup **every day at 2:30 a.m.** |
| 05 | Summarize disk usage **every day at noon**. |
| 06 | Archive weekly reports **every Sunday at 11:00 p.m.** |
| 07 | Generate a monthly report **on the first day of every month at 6:00 a.m.** |

## Intermediate · Combine fields, lists, ranges, and steps

| # | Scenario |
|---|---|
| 08 | Send a handoff reminder **Monday through Friday at 9:00 a.m.** |
| 09 | Run a maintenance check **Saturday and Sunday at 8:15 a.m.** |
| 10 | Synchronize inventory **every day at 6:00 a.m. and 6:00 p.m.** Use one entry. |
| 11 | Sample queue depth **at minutes 10, 25, and 50 of every hour**. Use one entry. |
| 12 | Check service status **every 15 minutes during hours 9 through 16, Monday through Friday**. The last run is at 4:45 p.m. |
| 13 | Generate a report **every Monday, Wednesday, and Friday at 7:30 a.m.** |
| 14 | Scan a batch directory **every two hours at minute 20**, starting at 12:20 a.m. each day. |
| 15 | Generate a quarterly report **at 5:00 a.m. on January 1, April 1, July 1, and October 1**. Use one entry. |
| 16 | Start an annual archive **every January 1 at 12:05 a.m.** |

## Advanced · Handle calendar boundaries and exceptions

| # | Scenario |
|---|---|
| 17 | Run an overnight check **at the top of each hour from 10:00 p.m. through 2:00 a.m., every night**. Use a single entry and list which hours it matches. |
| 18 | Run a weekend backup **at 11:30 p.m. on Saturday and Sunday and again at 1:30 a.m. the following mornings**. Use two entries and account for the change of day at midnight. |
| 19 | Generate a weekday opening report **every 30 minutes from 8:30 a.m. through 10:00 a.m., inclusive, Monday through Friday**. Use multiple entries to avoid 8:00 a.m. and 10:30 a.m. |
| 20 | Run maintenance **on the second Tuesday of every month at 3:00 a.m.** Use cron to select candidate dates and a shell condition to check the weekday. |

## Verify and clean up

1. Use `crontab -e` to add your entry for exercise 01 to your current user's crontab. Keep any existing entries.
2. Run `crontab -l` to confirm the entry was saved. After the next minute boundary, run `tail -n 5 "$HOME/cron-lab/runs.log"` and find the timestamped `ex01` line. If it is missing, check that cron is running and that the setup command wrote the `setup` line.
3. For each remaining exercise, list the expected run times or dates and compare them with the [solutions](SOLUTIONS.md). You can check schedules like the annual archive on paper.
4. Open `crontab -e` and delete the exercise entries you installed.
