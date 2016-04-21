using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BDFunction
{
    class DB
    {
        int Num_Class = 500;
        int Num_Course = 500;
        int Num_LessonMorn = 8;
        int Num_LessonEven = 5;
        int Num_LessonFac  = 5;
        int Num_Schedule = 500;
        String[] Courses = { "Математический анализ","Высшая алгебра","Геометрия","Технология программирования",
                             "Английский язык","Дифференциальные уравнения", "Теория функций комплексной переменной",
                             "Теоретическая механика", "Методы вычислений","Теория управления I (Вариационное исчисление)",
                             "Теория устойчивости движений","Технология программирования","Английский язык","Методы вычислений",
                             "Уравнения математической физики","Аналитическая динамика управляемых систем",
                             "Теория управления II","Теория управления III (Теория игр и исследование операций)",
                             "Теория вероятностей и математическая статистика","Физика. Колебания и волны",
                             "Физика. Электродинамика","Теория вероятностей и математическая статистика",
                             "Физика. Электродинамика","Физика. Электромеханические системы",
                             "Защита населения и территорий в чрезвычайных ситуациях","Безопасность труда",
                             "Философия","Математический анализ динамических систем","Проблемы современной философии",
                             "Экология"};
        private SqlConnection connection;
        public void Open()
        {
            string connectionString = @"Data Source=ELM-PC;Initial Catalog=Schedule;Integrated Security=True";
            connection = new SqlConnection(connectionString);

            connection.Open();
        }
        public void Close()
        {
            connection.Close();
        }
        public void fillClassroom()
        {
            SqlCommand command = new SqlCommand("P_ClassroomCreate", connection);
            // указываем, что команда представляет хранимую процедуру
            command.CommandType = System.Data.CommandType.StoredProcedure;
            // параметр для ввода имени
            command.Parameters.Add("@p_Number", System.Data.SqlDbType.Int);
            for (int i = 0; i < Num_Class; ++i)
            {
                command.Parameters["@p_Number"].Value = i + 1;
                command.ExecuteScalar();
            }
            
           /* String sqlExpression = "exec P_ClassroomCreate";
            SqlCommand command = new SqlCommand(sqlExpression, connection);
            for (int i = 0; i < Num_Class; ++i )
                command.ExecuteNonQuery();
            */
        }

        public void fillLesson()
        {
            DateTime durationMorn       = DateTime.Parse("1:30");
            DateTime durationEven       = DateTime.Parse("1:40");
            DateTime durationFaculta    = DateTime.Parse("2:05");

            DateTime startMorn      = DateTime.Parse("9:30");
            DateTime startEven      = DateTime.Parse("14:40");
            DateTime startFaculta   = DateTime.Parse("11:00");
            DateTime timePause      = DateTime.Parse("0:10");

            SqlCommand command = new SqlCommand("P_LessonCreate", connection);
            // указываем, что команда представляет хранимую процедуру
            command.CommandType = System.Data.CommandType.StoredProcedure;

            SqlParameter typeParam = new SqlParameter
            {
                ParameterName = "@p_Type",
                Value = 1
            };
            command.Parameters.Add(typeParam);

            SqlParameter startParam = new SqlParameter
            {
                ParameterName = "@p_StartTime",
                Value = startMorn.ToShortTimeString()
            };
            command.Parameters.Add(startParam);

            SqlParameter durationParam = new SqlParameter
            {
                ParameterName = "@p_Duration",
                Value = durationMorn.ToShortTimeString()
            };
            command.Parameters.Add(durationParam);
            
            for (int i = 0; i < Num_LessonMorn; ++i)
            {
                command.Parameters.Clear();

                typeParam.Value = 1;
                command.Parameters.Add(typeParam);

                startParam.Value = startMorn.ToShortTimeString();                
                startMorn = this.addTime(startMorn,durationMorn);
                startMorn = this.addTime(startMorn, timePause);
                command.Parameters.Add(startParam);

                durationParam.Value = durationMorn.ToShortTimeString();
                command.Parameters.Add(durationParam);
                command.ExecuteScalar();
            }


            for (int i = 0; i < Num_LessonEven; ++i)
            {
                command.Parameters.Clear();

                typeParam.Value = 2;
                command.Parameters.Add(typeParam);

                startParam.Value = startEven.ToShortTimeString();
                startEven = this.addTime(startEven, durationEven);
                startEven = this.addTime(startEven, timePause);
                command.Parameters.Add(startParam);

                durationParam.Value = durationEven.ToShortTimeString();
                command.Parameters.Add(durationParam);
                command.ExecuteScalar();
            }


            for (int i = 0; i < Num_LessonFac; ++i)
            {
                command.Parameters.Clear();

                typeParam.Value = 3;
                command.Parameters.Add(typeParam);

                startParam.Value = startFaculta.ToShortTimeString();
                startFaculta = this.addTime(startFaculta, durationFaculta);
                startFaculta = this.addTime(startFaculta, timePause); 
                command.Parameters.Add(startParam);

                durationParam.Value = durationFaculta.ToShortTimeString();
                command.Parameters.Add(durationParam);
                command.ExecuteScalar();
            }
        }

        public void fillCourse()
        {
            SqlCommand command = new SqlCommand("P_CourseCreate", connection);
            // указываем, что команда представляет хранимую процедуру
            command.CommandType = System.Data.CommandType.StoredProcedure;

            SqlParameter idParam = new SqlParameter
            {
                ParameterName = "@p_ID",
                Value = 1
            };
            SqlParameter nameParam = new SqlParameter
            {
                ParameterName = "@p_Name",
                Value = ""
            };
            command.Parameters.Add(nameParam);
            Random rand = new Random();
            for (int i = 0; i < Num_Course; ++i)
            {
                command.Parameters.Clear();

                nameParam.Value = Courses[rand.Next()%Courses.Length] + " " + (i + 1);
                command.Parameters.Add(nameParam);

                idParam.Value = i + 1;
                command.Parameters.Add(idParam);

                command.ExecuteScalar();
            }
        }

        public void fillSchedule()
        {
            SqlCommand command = new SqlCommand("P_ScheduleCreate", connection);
            // указываем, что команда представляет хранимую процедуру
            command.CommandType = System.Data.CommandType.StoredProcedure;

            command.Parameters.Add("@p_LessonType", System.Data.SqlDbType.Int);
            command.Parameters.Add("@p_LessonNumber", System.Data.SqlDbType.Int);
            command.Parameters.Add("@p_Classroom", System.Data.SqlDbType.Int);
            command.Parameters.Add("@p_CourseID", System.Data.SqlDbType.Int);
            command.Parameters.Add("@p_DayWeek", System.Data.SqlDbType.Int);
            command.Parameters.Add("@p_Result", System.Data.SqlDbType.Int);

            Random rand = new Random();
            int i = 0;
            int count = 0;
            while ( i < Num_Schedule)
            {
                int type =  rand.Next() % 3 + 1;
                command.Parameters["@p_LessonType"].Value = type;
                switch (type)
                {
                    case 1:
                        command.Parameters["@p_LessonNumber"].Value = rand.Next() % Num_LessonMorn + 1;
                        break;
                    case 2:
                        command.Parameters["@p_LessonNumber"].Value = rand.Next() % Num_LessonEven + 1;
                        break;
                    case 3:
                        command.Parameters["@p_LessonNumber"].Value = rand.Next() % Num_LessonFac + 1;
                        break;
                }
                command.Parameters["@p_Classroom"].Value = rand.Next() % Num_Class + 1;
                command.Parameters["@p_CourseID"].Value = rand.Next() % Num_Course + 1;
                command.Parameters["@p_DayWeek"].Value = rand.Next() % 6 + 1;
                command.Parameters["@p_Result"].Value = 2 ;
                command.Parameters["@p_Result"].Direction = System.Data.ParameterDirection.Output;
                command.ExecuteNonQuery();
                if( 1 == (int)command.Parameters["@p_Result"].Value)
                    ++i;
                    ++count;
            }
            Console.WriteLine(" " + count + " " + i);
        }
        DateTime addTime(DateTime x,DateTime y)
        {
            DateTime outTime = x;
            outTime = outTime.AddHours(y.Hour);
            outTime = outTime.AddMinutes(y.Minute);
            return outTime;

        }

        public void Clear()
        {
            String sqlExpression = "delete from ";
            SqlCommand command = new SqlCommand(sqlExpression + "Schedule", connection);
            command.ExecuteNonQuery();

            command.CommandText = sqlExpression + "Lesson";
            command.ExecuteNonQuery();

            command.CommandText = sqlExpression + "Classroom";
            command.ExecuteNonQuery();

            command.CommandText = sqlExpression + "Course";
            command.ExecuteNonQuery();
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            DB db = new DB();
            db.Open();
            db.Clear();
            db.fillClassroom();
            db.fillLesson();
            db.fillCourse();
            db.fillSchedule();
            db.Close();
            Console.Write("Ready");
            Console.Read();
        }
    }
}
