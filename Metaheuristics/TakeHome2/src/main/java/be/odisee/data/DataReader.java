package be.odisee.data;

import be.odisee.domain.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class DataReader {

    private final File eFile;
    private final File sFile;
    private List<Student> students;
    private List<Exam> exams;
    private List<Timeslot> timeslots;
    private final String eFileName;
    private final String sFileName;

    public DataReader(String examFileName, String studentsFileName) {
        eFile = new File(examFileName);
        sFile = new File(studentsFileName);
        this.eFileName = eFile.getName();
        this.sFileName = sFile.getName();
        readTimeSlots();
        readExams();
        readStudents();
    }

    private void readTimeSlots() {
        if (eFileName.endsWith(".crs")) {
            //read number of timeslots
            File timeSlotFile = new File("benchmarks/number_of_timeslots.txt");
            Scanner timeslotScanner;
            try {
                timeslotScanner = new Scanner(timeSlotFile);
                while (timeslotScanner.hasNextLine()) {
                    String nextLine = timeslotScanner.nextLine();
                    if (nextLine.startsWith(eFileName)) {
                        //ok goede gevonden
                        Scanner sc = new Scanner(nextLine);
                        sc.useDelimiter(":");
                        sc.next();
                        int numberOfTimeSlots = sc.nextInt();
                        timeslots = new ArrayList<>();
                        for (int i = 0; i < numberOfTimeSlots; i++) {
                            timeslots.add(new Timeslot(i));
                            // Lijst van tijdsloten (0-17) - timeslots.get(i).getID()
                           // System.out.println("tijdslot: " + timeslots.get(i).getID());
                        }
                        break;
                    }
                }
            } catch (FileNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }


    private void readExams() {
        Scanner scanner;
        try {
            scanner = new Scanner(eFile);
            this.exams = new LinkedList<Exam>();
            while (scanner.hasNextLine()) {
                String nextLine = scanner.nextLine();
                Scanner sc = new Scanner(nextLine);
                sc.useDelimiter(" ");
                int examID = sc.nextInt();
                int aantal = sc.nextInt();
                // System.out.println("examen:" + examID);
                Exam exam = new Exam(examID); // geen aantal nodig - examen capaciteit
                List<Student> sid = new LinkedList<Student>();
                exam.setStudentIDs(sid);
                this.exams.add(exam); // exam.getID(),
            }
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private void readStudents() {
        if (sFileName.endsWith(".stu")) {
            Scanner scanner;
            students = new LinkedList<Student>();
            try {
                scanner = new Scanner(sFile);
                int teller = 0;
                while (scanner.hasNextLine()) {
                    teller++;
                    String nextLine = scanner.nextLine();
                    Scanner sc = new Scanner(nextLine);
                    sc.useDelimiter(" ");
                    Student student = new Student(teller);
                    List<Integer> examIDList = new ArrayList<Integer>();
                    while (sc.hasNext()) {
                        examIDList.add(sc.nextInt());
                    }
                    for (Integer e : examIDList) {
                        Exam exam = exams.get(e -1);
                        exam.addSID(student);
                    }
                    student.setID(teller);
                    student.setExamIds(examIDList);
                    //System.out.println(student.getExamIds());
                    students.add(student); // teller, student

                }
            } catch (FileNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }


    public List<Student> getStudents() {
        return students;
    }

    public void setStudents(List<Student> students) {
        this.students = students;
    }

    public List<Exam> getExams() {
        return exams;
    }

    public void setExams(List<Exam> exams) {
        this.exams = exams;
    }

    public List<Timeslot> getTimeslots() {
        return timeslots;
    }

    public void setTimeslots(List<Timeslot> timeslots) {
        this.timeslots = timeslots;
    }

   /* public static void main(String... aArgs) {
        DataReader parser = new DataReader("benchmarks/lse-f-91.crs", "benchmarks/lse-f-91.stu");
        HashMap<Integer, Exam> exams = parser.getExams();
        Set<Integer> keys = exams.keySet();
        for (Integer i : keys) {
            Exam exam = exams.get(i);
            System.out.println(exam.getID() + " " + exam.getSID());
        }
        keys = parser.getStudents().keySet();
        for (Integer i : keys) {
            Student student = parser.getStudents().get(i);
            System.out.println(student.getID());
        }
        keys = exams.keySet();
        int totaal = 0;
        for (Integer i : keys) {
            Exam exam = exams.get(i);
            totaal += exam.getSID().size();
        }
        System.out.println(totaal);
    }*/

}
