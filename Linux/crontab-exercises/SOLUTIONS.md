# Crontab Exercise Solutions

Return to the [exercise worksheet](README.md) for setup and prompts.

## Beginner

```cron
* * * * * "$HOME/cron-lab/log-run.sh" ex01
*/5 * * * * "$HOME/cron-lab/log-run.sh" ex02
0 * * * * "$HOME/cron-lab/log-run.sh" ex03
30 2 * * * "$HOME/cron-lab/log-run.sh" ex04
0 12 * * * "$HOME/cron-lab/log-run.sh" ex05
0 23 * * 0 "$HOME/cron-lab/log-run.sh" ex06
0 6 1 * * "$HOME/cron-lab/log-run.sh" ex07
```

## Intermediate

```cron
0 9 * * 1-5 "$HOME/cron-lab/log-run.sh" ex08
15 8 * * 0,6 "$HOME/cron-lab/log-run.sh" ex09
0 6,18 * * * "$HOME/cron-lab/log-run.sh" ex10
10,25,50 * * * * "$HOME/cron-lab/log-run.sh" ex11
*/15 9-16 * * 1-5 "$HOME/cron-lab/log-run.sh" ex12
30 7 * * 1,3,5 "$HOME/cron-lab/log-run.sh" ex13
20 */2 * * * "$HOME/cron-lab/log-run.sh" ex14
0 5 1 1,4,7,10 * "$HOME/cron-lab/log-run.sh" ex15
5 0 1 1 * "$HOME/cron-lab/log-run.sh" ex16
```

For exercise 12, the hour range includes all matching minutes in hour 16, through 16:45. In exercise 14, the hour step selects 00, 02, 04, and so on through 22.

## Advanced

```cron
0 0-2,22-23 * * * "$HOME/cron-lab/log-run.sh" ex17

30 23 * * 0,6 "$HOME/cron-lab/log-run.sh" ex18
30 1 * * 0,1 "$HOME/cron-lab/log-run.sh" ex18

30 8 * * 1-5 "$HOME/cron-lab/log-run.sh" ex19
0,30 9 * * 1-5 "$HOME/cron-lab/log-run.sh" ex19
0 10 * * 1-5 "$HOME/cron-lab/log-run.sh" ex19

0 3 8-14 * * [ "$(date +\%u)" = 2 ] && "$HOME/cron-lab/log-run.sh" ex20
```

- **17** matches 22:00, 23:00, 00:00, 01:00, and 02:00 across midnight.
- **18** pairs Saturday night with Sunday morning and Sunday night with Monday morning.
- **19** matches 08:30, 09:00, 09:30, and 10:00 on weekdays. Each entry controls the minutes for its specific hour.
- **20** uses days 8 through 14 because the second occurrence of any weekday falls in that window. The shell checks for weekday `2`, Tuesday in ISO weekday numbering. Escape the percent sign as `\%` in the crontab command because cron treats an unescaped percent as a line break.
