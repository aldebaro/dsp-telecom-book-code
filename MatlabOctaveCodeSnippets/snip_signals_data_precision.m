str = 'Ranges for double before and after 0:\n%g to %g and %g to %g';
sprintf(str, -realmax, -realmin, realmin, realmax)
str = 'Ranges for float before and after 0:\n%g to %g and %g to %g';
sprintf(str,-realmax('single'),-realmin('single'), ...
		realmin('single'), realmax('single'))

