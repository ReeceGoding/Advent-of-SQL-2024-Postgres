/* Correct but painfully slow. Window functions would be better. */
SELECT
	best_elves.best_elf_id elf_1_id,
	worst_elves.worst_elf_id elf_2_id,
	best_elves.primary_skill shared_skill
FROM
(
	SELECT
		primary_skill,
		MIN(elf_id) best_elf_id
	FROM
		workshop_elves best_elves_per_skill
	WHERE EXISTS
	(
		SELECT
			1
		FROM
			workshop_elves highest_years_per_skill
		GROUP BY
			primary_skill
		HAVING
				highest_years_per_skill.primary_skill = best_elves_per_skill.primary_skill
			AND
				MAX(highest_years_per_skill.years_experience) = best_elves_per_skill.years_experience
	)
	GROUP BY
		primary_skill
) best_elves
JOIN
(
	SELECT
		primary_skill,
		MIN(elf_id) worst_elf_id
	FROM
		workshop_elves worst_elves_per_skill
	WHERE EXISTS
	(
		SELECT
			1
		FROM
			workshop_elves lowest_years_per_skill
		GROUP BY
			primary_skill
		HAVING
				lowest_years_per_skill.primary_skill = worst_elves_per_skill.primary_skill
			AND
				MIN(lowest_years_per_skill.years_experience) = worst_elves_per_skill.years_experience
	)
	GROUP BY
		primary_skill
) worst_elves
ON
		best_elves.primary_skill = worst_elves.primary_skill
	AND
		best_elves.best_elf_id <> worst_elves.worst_elf_id
ORDER BY
	shared_skill;