#!/usr/bin/perl
use strict;
use warnings;
use v5.10; # for say() function

use DBI;

#config params
#my $adm_year_of_interest = "20182019";
my @adm_years_of_interest = ("20142015", "20152016");

#MySQL database configuration
my $dsn = "DBI:mysql:academics";
my $username = "root";
my $password = 'onsjmd@123';

# connect to MySQL database
my %attr = ( PrintError=>0,  # turn off error reporting via warn()
             RaiseError=>1);   # turn on error reporting via die()           
 
our $dbh  = DBI->connect($dsn,$username,$password, \%attr);
#say "Connected to the MySQL database.";
print "<h1>Analysis of COL100 student grade data vis-a-vis prior CS exposure</h1>\n";
print "by Sorav Bansal (for COL100 Oversight Committee)<br>\n";
print "<p><b>Facts</b>:<ol>\n";
print "<li>I could only find prior-CS-exposure data for 2014-entry and 2015-entry students.</li>\n";
print "<li>There is a clear correlation between prior-CS-exposure and final COL100 grade</li>\n";
print "<li>Just to be completely sure, I also tried to see the statistics after removing all students who received a D or less (E/F/W/NF) while computing percentages (see columns titled non-weak students). In any case, the correlations remain largely similar, irrespective of whether we consider the weak students or not.</li>\n";
print "<li>However, there is also a clear correlation between prior-CS-exposure and final MTL100 grades.  I randomly picked another first-year course (MTL100) to see if the correlation is unique to COL100 or not.</li>\n";
print "<li>I do see slightly higher correlations for COL100 (than MTL100), say a few percentage points here or there, but nothing significant.</li>\n";
print "<li>What do I see from these results:\n";
print "</ol>\n";
print "<p><b>My inferences and opinions</b>:<ol type=\"a\">\n";
print "<li>For COL100 (and for all other courses actually), it is very clear that we get two categories of students based on their socio-economic backgrounds; let's call them \"haves\" and \"have-nots\" for lack of a better terminology. This categorization is not just based on this data, but also based on my experience teaching several subjects over the past around ten years at IITD.</li>\n";
print "<li>A fair treatment should involve: separate handling of these two categories of students; the have-nots should be started with more introductory material, while the haves can be started at a more advanced level. As far as I can tell, all of us agree on this aspect of our intake</li>\n";
print "<li>However, there are several practical issues with this, the most of important of which IMHO is: how do we distinguish the two categories; we need to worry about both precision and also care about being politically and socially correct in our categorization. Doing this practically in a curriculum-wide manner seems too hard to even attempt.</li>\n";
print "<li>This is the exact same effect that is playing out for COL100 too; but COL100 is definitely not unique in witnessing this effect. The data below shows that MTL100 has the exact same issue, and I would not be surprised at all if all our courses show the same issue.</li>\n";
print "<li>It just so happens that the two categories are also correlated with their typical class XII subjects; in particular, the haves seem to have more percentage of people who take CS in class XII. But treating these correlations as causal effects is wrong, as seen through MTL data: even though their class XII CS course has nothing to do with MTL110, students with prior CS exposure still seem to score higher on MTL110. In my opinion, this indicates that it is not their CS exposure but other issues that have causal effects both on their class XII subjects and their grades in IIT courses.</li>\n";
print "<li>At this point, I will not argue against a two-step COL100. However, if COL100 is made two-step, IMHO the criteria for deciding who needs one step vs. who needs two steps, cannot be based on their prior CS exposure, as we have just established that prior CS exposure is an incidentally correlated effect and not a cause for their COL100 performance.\n";
print "<ul><li>To use a crude analogy, let's say that in the context of reservation, the government is interested in supporting historically oppressed sections of the society; it also so happens that the oppressed sections of the society have shorter height on average, due to some nutritional correlation; based on this, should the government start making short height as the criteria for reservations?</li></ul>\n";
print "</li>\n";
print "<li>Finally: if COL100 is made two-step, IMHO we must also advocate MTL100 (and similarly other courses) to also be made two-step in the same breath. Why should this be a COL100 specific issue? Are we concerned about education in general, or is this some selfish exercise of the CS department?</li>\n";
print "</ol>\n";
foreach my $year (@adm_years_of_interest) {
  print "<h1><u>$year</u></h1>\n";
  draw_histogram_table($year);
}

#say "Disconnecting from the MySQL database.";
$dbh->disconnect();

sub draw_histogram_table
{
  my $year = shift;

  #there are duplicates in the mysql tables, so use associative arrays (not arrays)
  my %with_cs_exposure;
  my %without_cs_exposure;
  my %cs_exposure_map;
  my (%col100_grades, %eel100_grades);
  my (%col100_grade_inv, %eel100_grade_inv);

  print "<ul>\n";
  get_student_cs_exposure_data($year, \%cs_exposure_map, \%with_cs_exposure, \%without_cs_exposure);
  get_course_grades('COL100', $year, \%col100_grades, \%col100_grade_inv);
  get_course_grades('MTL100', $year, \%eel100_grades, \%eel100_grade_inv);
  print "</ul>\n";

  my $num_with_cs_exposure = keys %with_cs_exposure;
  my $num_without_cs_exposure = keys %without_cs_exposure;

  draw_table_for_course('COL100', $num_with_cs_exposure, $num_without_cs_exposure, \%cs_exposure_map, \%col100_grade_inv);
  draw_table_for_course('MTL100', $num_with_cs_exposure, $num_without_cs_exposure, \%cs_exposure_map, \%eel100_grade_inv);
}

sub draw_table_for_course
{
  my $course = shift;
  my $num_with_cs_exposure = shift;
  my $num_without_cs_exposure = shift;
  my $cs_exposure_map_ref = shift;
  my %cs_exposure_map = %{$cs_exposure_map_ref};
  my $course_grade_inv_ref = shift;
  my %course_grade_inv = %$course_grade_inv_ref;

  my $num_students_ignore_d_and_lower = 0;
  my $num_with_cs_exposure_ignore_d_and_lower = 0;
  my $num_without_cs_exposure_ignore_d_and_lower = 0;
  foreach my $grade (sort cmp_grade (keys %course_grade_inv)) {
    if ($grade eq "D" || $grade eq "E" || $grade eq "F" || $grade eq "NF" || $grade eq "W") {
      next;
    }
    my @students_at_grade = @{$course_grade_inv{$grade}};
    foreach my $entrynum (@students_at_grade) {
      $num_students_ignore_d_and_lower++;
      if (not defined $cs_exposure_map{$entrynum}) {
        next;
      } elsif ($cs_exposure_map{$entrynum} eq "N") {
        $num_without_cs_exposure_ignore_d_and_lower++;
      } elsif ($cs_exposure_map{$entrynum} eq "Y") {
        $num_with_cs_exposure_ignore_d_and_lower++;
      } else {
        die "not-reached\n";
      }
    }
  }
  print "<h2>$course</h2>\n";
  print "<ul>\n";
  print "<li>Total number of students with grade &gt;= C- (non-weak): $num_students_ignore_d_and_lower</li>\n";
  print "<li>Total number of students with grade &gt;= C- (non-weak) and with prior CS exposure: $num_with_cs_exposure_ignore_d_and_lower</li>\n";
  print "<li>Total number of students with grade &gt;= C- (non-weak) and without prior CS exposure: $num_without_cs_exposure_ignore_d_and_lower</li>\n";
  print "</ul>\n";

  print "<table border=\"1\">\n";
  print "<tr bgcolor=yellow><th>Grade \"<b>G</b>\"</th><th>Number of students with prior CS exposure with grade \"G\"</th><th>Number of students without prior CS exposure with grade \"G\"</th><th>Number of students for whom prior-CS-exposure information was not available</th><th>Cumulative number of students (with grade &gt;= G) with prior CS exposure</th><th>Cumulative number of students (with grade &gt;= G) without prior CS exposure</th><th>Cumulative fraction of students with prior CS exposure and with grade &gt;= G, as a fraction of total number of students with prior CS exposure (%)</th><th>Cumulative fraction of students without CS exposure and with grade &gt;= G as fraction of total number of students without prior CS exposure (%)</th><th><b>Cumulative fraction of students with CS exposure and with grade &gt;= G as fraction of number of non-weak students (i.e. &gt;= C- grade in the course) with prior CS exposure (%)</b></th><th><b>Cumulative fraction of students without CS exposure and with grade &gt;= G as fraction of number of non-weak students (i.e. &gt;= C- grade in the course) without prior CS exposure (%)</b></th></tr>\n";
  my $cum_with_cs_exposure = 0;
  my $cum_without_cs_exposure = 0;
  foreach my $grade (sort cmp_grade (keys %course_grade_inv)) {
    my @students_at_grade = @{$course_grade_inv{$grade}};
    my $num_with_cs_exposure_at_grade = 0;
    my $num_without_cs_exposure_at_grade = 0;
    my $num_cs_exposure_info_not_available = 0;
    foreach my $entrynum (@students_at_grade) {
      if (not defined $cs_exposure_map{$entrynum}) {
        #print "cs_exposure info not available for $entrynum\n";
        $num_cs_exposure_info_not_available++;
        next;
      }
      if ($cs_exposure_map{$entrynum} eq "N") {
        $num_without_cs_exposure_at_grade++;
      } elsif ($cs_exposure_map{$entrynum} eq "Y") {
        $num_with_cs_exposure_at_grade++;
      } else {
        die "not-reached\n";
      }
    }
    $cum_with_cs_exposure += $num_with_cs_exposure_at_grade;
    $cum_without_cs_exposure += $num_without_cs_exposure_at_grade;
    my $cum_with_cs_exposure_fraction = ($cum_with_cs_exposure * 100)/$num_with_cs_exposure;
    my $cum_without_cs_exposure_fraction = ($cum_without_cs_exposure * 100)/$num_without_cs_exposure;

    my $cum_with_cs_exposure_fraction_of_non_weak = ($cum_with_cs_exposure * 100)/$num_with_cs_exposure_ignore_d_and_lower;
    my $cum_without_cs_exposure_fraction_of_non_weak = ($cum_without_cs_exposure * 100)/$num_without_cs_exposure_ignore_d_and_lower;
    #print "$grade : $num_with_cs_exposure_at_grade    $num_without_cs_exposure_at_grade    $num_cs_exposure_info_not_available\n";
    printf("<tr><td>$grade</td><td>$num_with_cs_exposure_at_grade</td><td>$num_without_cs_exposure_at_grade</td><td>$num_cs_exposure_info_not_available</td><td>$cum_with_cs_exposure</td><td>$cum_without_cs_exposure</td><td>%.2f</td><td>%.2f</td><td><b>%.2f</b></td><td><b>%.2f</b></td></tr>\n", $cum_with_cs_exposure_fraction, $cum_without_cs_exposure_fraction, $cum_with_cs_exposure_fraction_of_non_weak, $cum_without_cs_exposure_fraction_of_non_weak);
  }
  print "</table>\n";
}

sub get_student_cs_exposure_data
{
  my $year = shift;
  my $cs_exposure_map = shift;
  my $with_cs_exposure = shift;
  my $without_cs_exposure = shift;

  my $sql = "SELECT id,cs12th FROM student_cgpa where admyear=$year";
  my $sth = $dbh->prepare($sql);
  # execute the query
  $sth->execute();
  #my $n = 0;
  while(my @row = $sth->fetchrow_array()){
     #printf("%s\t%s\n",$row[0],$row[1]);
     if ($row[1] eq "N") {
       #push(@$without_cs_exposure, $row[0]);
       $$without_cs_exposure{$row[0]} = 1;
     } elsif ($row[1] eq "Y") {
       #push(@$with_cs_exposure, $row[0]);
       $$with_cs_exposure{$row[0]} = 1;
     } else {
       die "not-reached\n";
     }
     #push(@$all_students, $row[0]);
     $$cs_exposure_map{$row[0]} = $row[1];
     #$n++;
  }
  my $num_students = keys %$cs_exposure_map;
  my $num_with_cs_exposure = keys %$with_cs_exposure;
  my $num_without_cs_exposure = keys %$without_cs_exposure;
  #print "Total n in $year: $n\n";
  print "<li>Total number of students admitted: $num_students</li>\n";
  print "<li>Number of students with prior CS exposure in $year: $num_with_cs_exposure</li>\n";
  print "<li>Number of students without prior CS exposure in $year: $num_without_cs_exposure</li>\n";
  $sth->finish();
}

sub get_course_grades
{
  my $course = shift;
  my $year = shift;
  my $course_grade_map = shift;
  my $course_grade_inv_map = shift;

  my $sql = "SELECT entryno,grade FROM course_grade where coucode='$course' and regyear='$year'";
  my $sth = $dbh->prepare($sql);
  # execute the query
  $sth->execute();
  while(my @row = $sth->fetchrow_array()){
     #printf("%s\t%s\n",$row[0],$row[1]);
     $$course_grade_map{$row[0]} = $row[1];
  }
  foreach my $entrynum (keys %$course_grade_map) {
    my $grade = $$course_grade_map{$entrynum};
    if (not defined $$course_grade_inv_map{$grade}) {
      my @arr = ();
      $$course_grade_inv_map{$grade} = \@arr;
      #print "initing array for $grade\n";
      #my @arr2 = @$course_grade_inv_map{$grade};
      #print "arr size $#arr\n";
      #print "arr2 size $#arr2\n";
    }
    my @arr = @{${$course_grade_inv_map}{$grade}};
    #print "arr size $#arr\n";
    #my @new_arr = (@arr, $entrynum);
    push(@arr, $entrynum);
    #$$course_grade_inv_map{$grade} = \@new_arr;
    ${$course_grade_inv_map}{$grade} = \@arr;
    #print "pushed $entrynum to $grade. new arr size $#arr\n";
  }
  $sth->finish();
  my $num_students_in_course = keys %$course_grade_map;
  print "<li>Total number of students who took $course: $num_students_in_course</li>\n";
  #foreach my $grade (sort cmp_grade (keys %$course_grade_inv_map)) {
  #  my @value = @{${$course_grade_inv_map}{$grade}};
  #  my $bucketsize = @value;
  #  print "Number of students with grade $grade: $bucketsize\n";
  #}
}

sub cmp_grade
{
  #my $a = shift;
  #my $b = shift;

  #print "a = $a, b = $b\n";
  if ($a eq $b) {
    return 0;
  }
  foreach my $grade ("A", "A-", "B", "B-", "C", "C-", "D", "NP", "E", "F", "W", "F", "NF") {
    if ($a eq $grade) {
      return -1;
    }
    if ($b eq $grade) {
      return 1;
    }
  }
  #print "a = $a, b = $b\n";
  die "not-reached\n";
}
