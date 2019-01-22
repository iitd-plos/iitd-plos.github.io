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

foreach my $year (@adm_years_of_interest) {
  print "<h1>$year</h1>\n";
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
  my %col100_grades;
  my %col100_grade_inv;

  print "<ul>\n";
  get_student_cs_exposure_data($year, \%cs_exposure_map, \%with_cs_exposure, \%without_cs_exposure);
  get_col100_grades($year, \%col100_grades, \%col100_grade_inv);

  my $num_with_cs_exposure = keys %with_cs_exposure;
  my $num_without_cs_exposure = keys %without_cs_exposure;

  my $num_students_ignore_d_and_lower = 0;
  my $num_with_cs_exposure_ignore_d_and_lower = 0;
  my $num_without_cs_exposure_ignore_d_and_lower = 0;
  foreach my $grade (sort cmp_grade (keys %col100_grade_inv)) {
    if ($grade eq "D" || $grade eq "E" || $grade eq "F" || $grade eq "NF" || $grade eq "W") {
      next;
    }
    $num_students_ignore_d_and_lower++;
    my @students_at_grade = @{$col100_grade_inv{$grade}};
    foreach my $entrynum (@students_at_grade) {
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
  print "<li>Total number of students with grade >= C-: $num_students_ignore_d_and_lower</li>\n";
  print "<li>Total number of students with grade >= C- and with prior CS exposure: $num_with_cs_exposure_ignore_d_and_lower</li>\n";
  print "<li>Total number of students with grade >= C- and without prior CS exposure: $num_without_cs_exposure_ignore_d_and_lower</li>\n";
  print "</ul>\n";

  print "<table border=\"1\">\n";
  print "<tr bgcolor=yellow><th>Grade</th><th>with prior CS</th><th>without prior CS</th><th>info not available</th><th>Cumulative with CS exposure</th><th>Cumulative without CS exposure</th><th>Cumulative with CS exposure as fraction of all</th><th>Cumulative without CS exposure as fraction of all</th><th><b>Cumulative with CS exposure as a fraction of non-weak</b></th><th><b>Cumulative without CS exposure as a fraction of non-weak</b></th></tr>\n";
  my $cum_with_cs_exposure = 0;
  my $cum_without_cs_exposure = 0;
  foreach my $grade (sort cmp_grade (keys %col100_grade_inv)) {
    my @students_at_grade = @{$col100_grade_inv{$grade}};
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

sub get_col100_grades
{
  my $year = shift;
  my $col100_grade_map = shift;
  my $col100_grade_inv_map = shift;

  my $sql = "SELECT entryno,grade FROM course_grade where coucode='COL100' and regyear='$year'";
  my $sth = $dbh->prepare($sql);
  # execute the query
  $sth->execute();
  while(my @row = $sth->fetchrow_array()){
     #printf("%s\t%s\n",$row[0],$row[1]);
     $$col100_grade_map{$row[0]} = $row[1];
  }
  foreach my $entrynum (keys %$col100_grade_map) {
    my $grade = $$col100_grade_map{$entrynum};
    if (not defined $$col100_grade_inv_map{$grade}) {
      my @arr = ();
      $$col100_grade_inv_map{$grade} = \@arr;
      #print "initing array for $grade\n";
      #my @arr2 = @$col100_grade_inv_map{$grade};
      #print "arr size $#arr\n";
      #print "arr2 size $#arr2\n";
    }
    my @arr = @{${$col100_grade_inv_map}{$grade}};
    #print "arr size $#arr\n";
    #my @new_arr = (@arr, $entrynum);
    push(@arr, $entrynum);
    #$$col100_grade_inv_map{$grade} = \@new_arr;
    ${$col100_grade_inv_map}{$grade} = \@arr;
    #print "pushed $entrynum to $grade. new arr size $#arr\n";
  }
  $sth->finish();
  my $num_students_in_col100 = keys %$col100_grade_map;
  print "<li>Total number of students who took COL100: $num_students_in_col100</li>\n";
  #foreach my $grade (sort cmp_grade (keys %$col100_grade_inv_map)) {
  #  my @value = @{${$col100_grade_inv_map}{$grade}};
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
