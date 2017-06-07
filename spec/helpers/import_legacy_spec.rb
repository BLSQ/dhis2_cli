
# frozen_string_literal: true

require_relative '../../lib/dhis2_cli'

dhis2 = Dhis2::Client.new(
  url: ENV['DHIS2_URL'],
  user: ENV['DHIS2_USER'],
  password: ENV['DHIS2_PASSWORD']
)

quantity_pma = {
  file_path:  './spec/helpers/PBF_Manager_LIT_2016_pma_quantity.csv',
  frequency: 'monthly',
  activities: [
    { label: 'Nouvelle consultation curative - infirmiers (nvx cas)', claimed: 'I961i90uUz1', validated: 'FwBl7khxY1h', index: 0 },
    { label: 'Nouvelle consultation curative - médecin (nvx cas)', claimed: 'r6NG3gn0suZ', validated: 'XfzKkEhrjAX', index: 1 },
    { label: 'Consultation externe nouveau cas - indigent', claimed: 'qUtqU7iYCtk', validated: 'IFeiZ0NHAUw', index: 2 },
    { label: "Journées d'hospitalisation", claimed: 'LrVuWmabWat', validated: 'fmbxJN7I6Gd', index: 3 },
    { label: "Journée d'hospitalisation - indigent", claimed: 'Q4YfBPPVwvS', validated: 'bWhFV5aLNyR', index: 4 },
    { label: 'Petite chirurgie', claimed: 'JjXmbxgIGoi', validated: 'kkanscjGYYe', index: 5 },
    { label: 'Petite chirurgie - indigent', claimed: 'MI81fnsHqzb', validated: 'tjd10veh8Ve', index: 28 },
    # ??? Références arrivées à l'hôpital
    { label: 'Cas IST traités selon protocole', claimed: 'ZzvPeVHAW8r', validated: 'YtrcJfMKQlJ', index: 7 },
    { label: 'Enfants completement vaccines', claimed: 'ntiCVvaK9vf', validated: 'YjiSf512AT6', index: 8 },
    { label: 'TPI1 ou TPI2 ou TPI3', claimed: 'YdHrjUy1P7c', validated: 'xSCsY7nZ8H3', index: 9 },
    { label: 'VAT2 ou VAT3 ou VAT4 ou VAT5', claimed: 'lb3nyFEM61r', validated: 'WLFUvKzVRup', index: 10 },
    { label: 'Distribution Vit A', claimed: 'jRyJZZ7QHJP', validated: 'imRzE5nOnrP', index: 11 },
    { label: 'CPN1 ou CPN2 ou CPN3 ou CPN4', claimed: 'Yoo0iZIYdkR', validated: 'Qj480BkHLK1', index: 12 },
    { label: 'Accouchements eutociques', claimed: 'pzWtrJXrYYI', validated: 'SbhKv1FFN2S', index: 13 },
    { label: 'Accouchement eutociques - indigent', claimed: 'KTjB9kegMwy', validated: 'pjagAx2ZbPH', index: 29 },
    { label: 'Accouchement dystocique (ventouse, forceps)', claimed: 'CZxmsKDkVJc', validated: 'b2BMjHV3ibG', index: 14 },
    { label: 'Accouchement dystociques - indigent', claimed: 'LLc78x5o4Xw', validated: 'K37g4ivKZFt', index: 30 },
    { label: 'Curetage après avortement spontané(ou indication médicale)', claimed: 'MuT30AXipKP', validated: 'L9rTR2JmmN5', index: 15 },
    { label: 'Consultation postnatale', claimed: 'Nd7qy4mC4Oq', validated: 'l7q6CesVLZr', index: 31 },
    { label: 'PF : Nouvelles ou Ancienne acceptantes pilules ou injectables', claimed: 'o3eVfwlwT12', validated: 'RRdUDNXHdL8', index: 16 },
    { label: 'PF: Implants ou DIU', claimed: 'PNlIvVdaT3Y', validated: 'ZLazfwgskO6', index: 17 },
    { label: 'Dépistage volontaire du VIH/SIDA y compris femmes enceintes', claimed: 'mkv1L7Rx2SG', validated: 'F69Ld79A6lV', index: 18 },
    { label: 'Femme enceinte VIH+ sous protocole ARV prophylaxie', claimed: 'LsqjnvYBvKt', validated: 'SCgQoyXMtPL', index: 19 },
    { label: 'Prise en charge du nouveau-ne d une femme VIH +', claimed: 'heo8lsSbO0k', validated: 'UhVrbx6aKTB', index: 20 },
    { label: 'Depistage des cas TBC positifs par mois', claimed: 'hGnW1ltJaS6', validated: 'IA5uKOjI9F2', index: 21 },
    { label: 'Cas TBC traités et guéris', claimed: 'kRhs5zFrcGK', validated: 'M1fe7D3GdFB', index: 22 },
    { label: 'Visite à domicile selon protocole', claimed: 'NpV1ek5asMh', validated: 'Oprm8IBzzZv', index: 23 },
    { label: 'Cas référés par relais communautaire et arrivé (plafond 5% des CE)', claimed: 'u9CvRPjdC69', validated: 'SEOSbjfYQKr', index: 24 },
    { label: 'Cas d’abandon récupérée (plafond 2% CE)', claimed: 'SVh2i9rKa00', validated: 'fy41vyAEsb0', index: 25 },
    { label: 'Enfant de 6-59 mois PEC pour malnutrition aigüe modérée (MAM)', claimed: 'DkpoYp11Gmv', validated: 'GjL2sn7q1hW', index: 26 },
    { label: 'Enfant de 6-59 mois PEC malnutrition aigüe sévère (MAS)', claimed: 'zPLPrRRzFte', validated: 'Sd9yAMPJDmQ', index: 27 }
  ]
  # 32 Bonus d'Amélioration de Qualité (BAQ)
}

quality_pma = {
  file_path:  './spec/helpers/PBF_Manager_LIT_2016_pma_quality.csv',
  frequency: 'quaterly',
  activities: [
    { label: 'General indicators', verified: 'OAgtfejG2Zz', index: 0 },
    { label: 'Quaterly Business Plan', verified: 'kkky2iQfdM8', index: 1 },
    { label: 'Financial Section', verified: 'pC74MJeRbjf', index: 2 },
    { label: 'Hygiene and sanitation', verified: 'UUBBZtJMvMn', index: 3 },
    { label: 'Outpatient Consultations/Emergency', verified: 'AAjdXukGliE', index: 4 },
    { label: 'Family Planning', verified: 'LLaIVemldk0', index: 5 },
    { label: 'Laboratory', verified: 'DULnZ1AfrSQ', index: 6 },
    { label: 'Wards/Observation room', verified: 'zTv2hXMmgb9', index: 7 },
    { label: 'Drug/Pharmacy management', verified: 'YV8QNFcwGB7', index: 8 },
    { label: 'Tracer drugs', verified: 'pNqoEtMX1XW', index: 9 },
    { label: 'Maternity', verified: 'utBGQijstR2', index: 10 },
    { label: 'Minor Surgery', verified: 'DSZkFKvUCOA', index: 11 },
    { label: 'Tuberculosis', verified: 'eYzLUYxs6ab', index: 12 },
    { label: 'Vaccination', verified: 'KJKcwVoQca2', index: 13 },
    { label: 'Ante-Natal Consultation (ANC)', verified: 'p6E0gDyeyrl', index: 14 },
    { label: 'Fight against HIV/AIDS', verified: 'mmHJHOVKcQG', index: 15 }
  ]
}

MONTH_TO_QUARTER = {
  1 => 1,
  2  => 1,
  3  => 1,
  4  => 2,
  5  => 2,
  6  => 2,
  7  => 3,
  8  => 3,
  9  => 3,
  10 => 4,
  11 => 4,
  12 => 4
}.freeze

MONTHS = {
  'Decembre' => '12',
  'November' => '11',
  'Octobre' => '10',
  'Septembre' => '09',
  'Août' => '08',
  'Juillet' => '07',
  'Juin' => '06',
  'Mai' => '05',
  'Avril' => '04',
  'Mars' => '03',
  'Février' => '02',
  'Janvier' => '01'
}.freeze

FOSA_MAPPING = {
  'CENTRE DE SANTE GRACE DIVINE IHC' => 'CS GRACE DIVINE',
  'Cabinet de soins polyvalent du stade IHC' => 'CABINET DE SOINS DU STADE',
  'Centre de santé et maternité saint Raphael de PK14 IHC' => 'CS ST RAPHAEL PK14',
  'Centre Medical de Ndogbong IHC' => 'CENTRE MEDICAL NDOGBONG',
  'Cabinet de Soins Sainte Régine IHC' => 'CS SAINTE REGINE',
  'Centre Médical des Merveilles IHC' => 'CLINIQUE DES MERVEILLES',
  'Centre de Santé espoir IHC' => 'CENTRE DE SANTE ESPOIR',
  'Infirmerie du Genie Militaire IHC' => 'INFIRMERIE GENIE MILITAIRE',
  'Centre de Santé FAPROMEL  IHC' => 'CS FAPROMEL',
  'Anne Rose IHC' => 'CS SAINTE ANNE ROSE',
  'Centre Médical de PK13 IHC' => 'CENTRE MEDICAL PK 13',
  'Charly IHC' => 'CS CHARLY',
  'Secours Médical Camerounais IHC' => 'SECOURS MEDICAL CAMEROUNAIS PK 12',
  'Centre de santé saint Raphael de Nyalla IHC' => 'CS ST RAPHAEL DE NYALLA',
  ' CS sainte marie de mandjap IHC' => 'CSI STE MARIE DE MANDJAP',
  'Centre de Santé et Maternité Sainte Thérèse de PK10 IHC' => 'ST THERESE HEALT CTRE AND MATERNITY',
  'Centre de Santé Intégré Saint Joseph IHC' => 'CS ST JOSEPH PK13',
  'USGO Kazel et Marie IHC' => 'USGO KAZEL ET MARIE',
  'Centre Infirmier B. O. IHC' => 'CENTRE INFIRMIER BO',
  'Centre de Santé Val de Grace de PK14 IHC' => 'CS VAL DE GRACE',
  'Clinique de l’espérance IHC' => 'CLINIQUE DE L’ESPERANCE',
  'Cs  Santa Rosa CL' => 'CS SANTA ROSA',
  'CS sainte Marie PK 18 IHC' => 'CS STE MARIE DE PK18',
  'CS ROSA Noella IHC' => 'CS ROSA NOELLA',
  'Fondation Médicale St. Michel IHC'=> 'FONDATION MEDICAL SAINT MICHEL PK 11'
}.freeze

def month_to_number(month_name)
  number = MONTHS[month_name]
  raise "no value for #{month_name}" unless number
  number
end

def format_period(period, frequency)
  if frequency == 'monthly'
    period.join('')
  elsif frequency == 'quaterly'
    "#{period[0]}Q#{MONTH_TO_QUARTER[period[1].to_i]}"
  else
    raise "not supported frequency #{frequency}"
  end
end

def read_file(file_path)
  headers = CSV.open(file_path, 'r', &:first)
  lines = CSV.read(file_path)
  lines.shift
  lines.each_with_index.map do |entity_line, index|
    OpenStruct.new Hash[headers.zip entity_line].merge(line_number: index + 1)
  end
end

orgunits_by_name = dhis2.organisation_units.list(page_size: 100_000).map do |ou|
  [ou.display_name, ou.id]
end.to_h

descriptor = OpenStruct.new quality_pma

def to_dhis2_values(descriptor, values, orgunits_by_name)
  activities = descriptor.activities
  puts "values : #{values.size}"
  puts "activities: #{activities.size}"
  final_values = []
  fosa_names = {}
  values.each do |value|
    activities.each do |activity|
      index = activity[:index]
      state_method = (activity.keys.map(&:to_s) - ['label']).map { |key| [key.to_sym, "#{key}_#{index}"] }.to_h
      dhis2_values = state_method.map { |state, method| [state, value.send(method)] }.map do |v|
        # puts "V: #{v}"
        state = v.first
        current_value = v.last
        next unless current_value
        # puts "#{state} #{current_value}"
        period = [
          value.send('Annee'),
          month_to_number(value.send('Mois'))
        ]
        original_fosa_name = value.send('Formation Sanitaire')
        fosa_name = FOSA_MAPPING[original_fosa_name] || original_fosa_name
        fosa_id = orgunits_by_name[fosa_name]
        unless fosa_id
          raise "no matching name #{original_fosa_name} #{fosa_name} #{fosa_id}"
          next
        end
        v = {
          data_element: activity[state],
          value: current_value,
          org_unit: fosa_id,
          period: format_period(period, descriptor.frequency),
          comment: "legacy-L#{value.line_number}-#{index}-#{period.join('-')}-#{activity[:label]}-#{original_fosa_name}"
        }
        fosa_names[value.send('Formation Sanitaire')] = fosa_name
        v
      end
      final_values << dhis2_values
    end
  end
  final_values = final_values.flatten.compact
end

values = read_file(descriptor.file_path).select { |v| v['District'] == 'Cite des palmiers' }
final_values = to_dhis2_values(descriptor, values, orgunits_by_name)

puts final_values
puts final_values.size

selected_values = final_values#.select {|v| v[:org_unit] == "N9PqavAHwTp" }
puts '*******************'
puts selected_values
status = dhis2.data_value_sets.create(selected_values)
puts status.raw_status.to_json
